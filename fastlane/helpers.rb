
def replace(file_path, old_string, new_string)
  # Check if the file exists
  unless File.file?(file_path)
    UI.user_error!("File not found: #{file_path}")
  end

  # Replace the string
  new_content = File.read(file_path).gsub(old_string, new_string)

  # Write the updated content back to the file
  File.open(file_path, "w") { |file| file.puts new_content }

  UI.success("Replaced '#{old_string}' with '#{new_string}' in #{file_path}")
end

def inject_staging_environment(app)
  staging_hostname = ENV["STAGING_HOST_NAME"]
  if staging_hostname.nil?
    UI.abort_with_message!("Staging build requested but no STAGING_HOST_NAME environment variable set. Unable to continue.")
  end

  app_identifier_staging_suffix = '.staging'

  current_bundle_id = get_product_bundle_id(
    project_filepath: app.project,
    scheme: app.scheme
  )

  if current_bundle_id.end_with?(app_identifier_staging_suffix)
    UI.message("The current bundle id already ends in #{app_identifier_staging_suffix}. No changes made.")
  else
    desired_bundle_id = "#{current_bundle_id}#{app_identifier_staging_suffix}"

    update_app_identifier(
      xcodeproj: app.project,
      plist_path: app.plist,
      app_identifier: desired_bundle_id,
    )

    UI.message("Updated bundle ID to: #{desired_bundle_id}")

    profile_specifier = "match AdHoc"
    replace(
      "#{app.project}/project.pbxproj",
      "#{profile_specifier} #{current_bundle_id}",
      "#{profile_specifier} #{desired_bundle_id}"
    )
    replace("#{@project_root_path}/Source/Models/Constants/JPConstants.h", ".judopay.com", ".#{staging_hostname}}")
  end
end

def revert_staging_environment(app)
  reset_git_repo(
    force: true,
    files: ["#{@project_root_path}/Source/Models/Constants/JPConstants.h", "#{app.project}/project.pbxproj"]
  )
end

def bump_build_number(app, environment)
  firebase_app_id = app.firebase_app_id(environment)

  if firebase_app_id.nil?
    UI.important("Firebase app ID is not set for the specified app. Skipping build number increment.")
    return
  end

  latest_release = firebase_app_distribution_get_latest_release(app: firebase_app_id)
  current_version = latest_release.nil? ? 0 : latest_release[:buildVersion].to_i
  
  increment_build_number({
    xcodeproj: app.project,
    build_number:  current_version + 1
  })
end

def package_instrumented_tests(app)
  FileUtils.mkdir_p(@fl_output_dir)
  Dir.chdir("#{@derived_data_path}/Build/Products") do
    sh("zip -r #{@fl_output_dir}/#{app.scheme}.zip Debug-iphoneos #{app.scheme}_*.xctestrun")
  end
end

class SampleApp
  attr_reader :bootstrap_script, :flavor, :instrumented_tests

  def initialize(firebase_app_id:, flavor:, path:, bootstrap_script: nil, instrumented_tests: false)
    @bootstrap_script = bootstrap_script
    @firebase_app_id = firebase_app_id
    @flavor = flavor
    @instrumented_tests = instrumented_tests
    @path = path
  end

  def firebase_app_id(environment)
    return @firebase_app_id[environment]
  end

  def project
    project_path = "#{@path}/#{@scheme}.xcodeproj"
    puts("Project path: #{project_path}")
    return File.directory?(project_path) ? project_path : nil
  end

  def plist
    plist_path = "#{@path}/#{@scheme}/#{@scheme}/Info.plist"
    return File.file?(plist_path) ? plist_path : nil
  end

  def podfile
    podfile_path = "#{@path}/#{@scheme}/Podfile"
    return File.file?(podfile_path) ? podfile_path : nil
  end

  def scheme
    return File.basename(@path)
  end

  def ui_test_plan
    test_plan = "#{@scheme}TestPlan"
    return File.file?("#{@path}/#{@ui_test_scheme}/#{test_plan}.xctestplan") ? test_plan : nil
  end

  def ui_test_scheme
    ui_test_scheme = "#{@scheme}UITests"
    return File.directory?("#{@path}/#{ui_test_scheme}") ? ui_test_scheme : nil
  end

  def unit_test_scheme
    unit_test_scheme = "#{@scheme}Tests"
    return File.directory?("#{@path}/#{unit_test_scheme}") ? unit_test_scheme : nil
  end
  
  def workspace
    workspace_path = "#{@path}/#{app_scheme}/#{app_scheme}.xcworkspace"
    return File.directory?(workspace_path) ? workspace_path : nil
  end
end
