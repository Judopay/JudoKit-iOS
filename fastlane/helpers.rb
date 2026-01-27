require "fastlane_core/ui/ui"
require "rest-client"

def replace(file_path:, old_string:, new_string:)
  # Check if the file exists
  unless File.file?(file_path)
    puts("File not found: #{file_path}")
  end

  # Replace the string
  new_content = File.read(file_path).gsub(old_string, new_string)

  # Write the updated content back to the file
  File.open(file_path, "w") { |file| file.puts new_content }

  puts("Replaced '#{old_string}' with '#{new_string}' in #{file_path}")
end

def update_provisioning(app:, profile_type:, code_signing_identity: "Apple Development")
  update_project_team(path: app.project, teamid: ENV["FASTLANE_TEAM_ID"])

  app_identifier = get_product_bundle_id(project_filepath: app.project, scheme: app.scheme)

  targets = [[app_identifier, app.scheme]]
  if app.ui_test_scheme
    ui_id = get_product_bundle_id(project_filepath: app.project, scheme: app.ui_test_scheme)
    targets << ["#{ui_id}.*", app.ui_test_scheme]
  end

  targets.each do |identifier, scheme_name|
    sync_code_signing(type: profile_type, app_identifier: identifier, readonly: is_ci)
    profile_path = ENV["sigh_#{identifier}_#{profile_type}_profile-path"]
    update_project_provisioning(
      xcodeproj: app.project,
      target_filter: /^#{scheme_name}$/,
      profile: profile_path,
      code_signing_identity: code_signing_identity
    )
    puts("Updated provisioning profile for #{scheme_name} to: #{profile_path}")
  end
end

def inject_staging_environment(app:, sdk_root_path:)
  staging_hostname = ENV["STAGING_HOST_NAME"]
  if staging_hostname.nil?
    raise "Staging build requested but no STAGING_HOST_NAME environment variable set. Unable to continue."
  end

  app_identifier_staging_suffix = ".staging"

  current_bundle_id = get_product_bundle_id(
    project_filepath: app.project,
    scheme: app.scheme
  )

  if current_bundle_id.end_with?(app_identifier_staging_suffix)
    puts("The current bundle id already ends in #{app_identifier_staging_suffix}. No changes made.")
  else
    desired_bundle_id = "#{current_bundle_id}#{app_identifier_staging_suffix}"

    update_app_identifier(
      xcodeproj: app.project,
      plist_path: app.plist,
      app_identifier: desired_bundle_id
    )

    puts("Updated bundle ID of #{app.project} to: #{desired_bundle_id}")

    replace(
      file_path: "#{sdk_root_path}/Source/Models/Constants/JPConstants.h",
      old_string: ".judopay.com",
      new_string: ".#{staging_hostname}"
    )
    replace(
      file_path: "#{sdk_root_path}/Source/Services/ApiService/Session/JPSession.m",
      old_string: "judopay.com",
      new_string: staging_hostname.to_s
    )
    replace(
      file_path: "#{sdk_root_path}/Source/Services/ApiService/Session/JPSession.m",
      old_string: "SuY75QgkSNBlMtHNPeW9AayE7KNDAypMBHlJH9GEhXs=",
      new_string: "MSRt/ad3CuiVlkcO6NMNJPXHjLK3jG6WpBxjSROooTE="
    )
    puts("Updated provisioning profile specifier and constants for staging environment.")
  end
end

def revert_staging_environment(app:, sdk_root_path:)
  reset_git_repo(
    force: true,
    files: [
      "#{sdk_root_path}/Source/Models/Constants/JPConstants.h",
      "#{sdk_root_path}/Source/Services/ApiService/Session/JPSession.m",
      "#{app.project}/project.pbxproj"
    ]
  )
end

def bump_build_number(app:, environment:)
  firebase_app_id = app.firebase_app_id(environment: environment)

  if firebase_app_id.nil?
    puts("Firebase app ID is not set for the specified app. Skipping build number increment.")
    return
  end

  latest_release = firebase_app_distribution_get_latest_release(app: firebase_app_id)
  current_version = latest_release.nil? ? 0 : latest_release[:buildVersion].to_i

  increment_build_number({
    xcodeproj: app.project,
    build_number: current_version + 1
  })
  puts("Bumped build number to #{current_version + 1}")
end

def package_instrumented_tests(app:, input_dir:, output_dir:, output_file:)
  FileUtils.mkdir_p(output_dir)
  # Firebase requires the entire Debug-iphoneos directory and the .xctestrun file
  # BrowserStack requires the Debug-iphoneos/<scheme>-Runner.app directory placed in the root of the zip file and the .xctestrun file
  Dir.chdir(input_dir) do
    FileUtils.cp_r("Debug-iphoneos/#{app.ui_test_scheme}-Runner.app", input_dir)
    sh("zip -r #{output_dir}/#{output_file} Debug-iphoneos #{app.ui_test_scheme}_*.xctestrun #{app.ui_test_scheme}-Runner.app")
  end
  puts("Instrumented tests packaged successfully into #{output_dir}/#{output_file}")
end

def send_rest_request(url:, method:, payload:, user:, password:)
  response = RestClient::Request.execute(
    method: method,
    url: url,
    user: user,
    password: password,
    payload: payload
  )
  JSON.parse(response.to_s)
rescue RestClient::ExceptionWithResponse => err
  puts(err.response)
  begin
    error_response = JSON.parse(err.response.to_s)["error"]
  rescue
    error_response = err.response.to_s
  end
  raise("Rest request failed: #{error_response}")
rescue => error
  raise("Rest request failed: #{error.message}")
end

def upload_xctestrun_to_browserstack(browserstack_username:, browserstack_access_key:, file_path:)
  puts("Uploading #{file_path} to BrowserStack...")
  response = send_rest_request(
    method: :post,
    url: "https://api-cloud.browserstack.com/app-automate/xcuitest/v2/test-suite",
    user: browserstack_username,
    password: browserstack_access_key,
    payload: {
      multipart: true,
      file: File.new(file_path, "rb")
    }
  )

  if !response["test_suite_url"].nil?
    puts("Successfully uploaded xctestrun file to BrowserStack: #{response}")
    response["test_suite_url"]
  else
    raise("Failed to upload xctestrun file. Response did not contain test_suite_url: #{response}")
  end
end

def run_xctestrun_on_browserstack(
  browserstack_username:,
  browserstack_access_key:,
  project:,
  app_url:,
  test_suite_url:,
  devices:,
  build_tag:
)
  response = send_rest_request(
    method: :post,
    url: "https://api-cloud.browserstack.com/app-automate/xcuitest/v2/xctestrun-build",
    user: browserstack_username,
    password: browserstack_access_key,
    payload: {
      app: app_url,
      testSuite: test_suite_url,
      devices: devices,
      networkLogs: true,
      deviceLogs: true,
      project: project,
      buildTag: build_tag
    }
  )

  puts("Successfully triggered tests on BrowserStack: #{response}")
end

def find_app_by_flavor(sample_apps:, flavor:)
  app = sample_apps.find { |a| a.flavor == flavor }

  if app.nil?
    available_flavors = sample_apps.map(&:flavor).join(", ")
    UI.user_error!("App with flavor '#{flavor}' not found. Available flavors: #{available_flavors}")
  end

  app
end

class SampleApp
  attr_reader :bootstrap_script, :flavor, :instrumented_tests, :smoke_test_list

  def initialize(firebase_app_id:, flavor:, path:, bootstrap_script: nil, fabrick3ds_test_list: nil, instrumented_tests: false, smoke_test_list: nil)
    @bootstrap_script = bootstrap_script
    @fabrick3ds_test_list = fabrick3ds_test_list
    @firebase_app_id = firebase_app_id
    @flavor = flavor
    @instrumented_tests = instrumented_tests
    @path = path
    @smoke_test_list = smoke_test_list
  end

  def firebase_app_id(environment:)
    @firebase_app_id.fetch(:"#{environment}", nil)
  end

  def project
    project_path = "#{@path}/#{scheme}.xcodeproj"
    File.directory?(project_path) ? project_path : nil
  end

  def plist
    plist_path = "#{@path}/#{scheme}/Info.plist"
    File.file?(plist_path) ? plist_path : nil
  end

  def podfile
    podfile_path = "#{@path}/Podfile"
    File.file?(podfile_path) ? podfile_path : nil
  end

  def scheme
    File.basename(@path)
  end

  def ui_test_plan
    test_plan = "#{scheme}TestPlan"
    File.file?("#{@path}/#{ui_test_scheme}/#{test_plan}.xctestplan") ? test_plan : nil
  end

  def ui_test_scheme
    ui_test_scheme = "#{scheme}UITests"
    (File.directory?("#{@path}/#{ui_test_scheme}") && Dir["#{@path}/#{ui_test_scheme}/*"].length > 1) ? ui_test_scheme : nil
  end

  def unit_test_scheme
    unit_test_scheme = "#{scheme}Tests"
    File.directory?("#{@path}/#{unit_test_scheme}") ? unit_test_scheme : nil
  end

  def workspace
    workspace_path = "#{@path}/#{scheme}.xcworkspace"
    File.directory?(workspace_path) ? workspace_path : nil
  end
end
