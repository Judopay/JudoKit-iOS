def replace(file_path:, old_string:, new_string:)
  # Check if the file exists
  unless File.file?(file_path)
    raise("File not found: #{file_path}")
  end

  # Replace the string
  new_content = File.read(file_path).gsub(old_string, new_string)

  # Write the updated content back to the file
  File.open(file_path, "w") { |file| file.puts new_content }

  puts("Replaced '#{old_string}' with '#{new_string}' in #{file_path}")
end

def inject_staging_environment(app:, sdk_root_path:)
  staging_hostname = ENV["STAGING_HOST_NAME"]
  if staging_hostname.nil?
    raise "Staging build requested but no STAGING_HOST_NAME environment variable set. Unable to continue."
  end

  app_identifier_staging_suffix = '.staging'

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
      app_identifier: desired_bundle_id,
    )

    puts("Updated bundle ID to: #{desired_bundle_id}")

    profile_specifier = "match AdHoc"
    replace(
      file_path: "#{app.project}/project.pbxproj",
      old_string: "#{profile_specifier} #{current_bundle_id}",
      new_string: "#{profile_specifier} #{desired_bundle_id}"
    )
    replace(
      file_path: "#{sdk_root_path}/Source/Models/Constants/JPConstants.h",
      old_string: ".judopay.com",
      new_string: ".#{staging_hostname}}"
    )
  end
end

def revert_staging_environment(app:, sdk_root_path:)
  reset_git_repo(
    force: true,
    files: ["#{sdk_root_path}/Source/Models/Constants/JPConstants.h", "#{app.project}/project.pbxproj"]
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
    build_number:  current_version + 1
  })
end

def package_instrumented_tests(app:, input_dir:, output_dir:)
  FileUtils.mkdir_p(output_dir)
  Dir.chdir(input_dir) do
    sh("zip -r #{output_dir}/#{app.ui_test_scheme}.zip Debug-iphoneos #{app.ui_test_scheme}_*.xctestrun")
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

  def firebase_app_id(environment:)
    return @firebase_app_id.fetch(:"#{environment}", nil)
  end

  def project
    project_path = "#{@path}/#{scheme}.xcodeproj"
    return File.directory?(project_path) ? project_path : nil
  end

  def plist
    plist_path = "#{@path}/#{scheme}/Info.plist"
    return File.file?(plist_path) ? plist_path : nil
  end

  def podfile
    podfile_path = "#{@path}/Podfile"
    return File.file?(podfile_path) ? podfile_path : nil
  end

  def scheme
    return File.basename(@path)
  end

  def ui_test_plan
    test_plan = "#{scheme}TestPlan"
    return File.file?("#{@path}/#{ui_test_scheme}/#{test_plan}.xctestplan") ? test_plan : nil
  end

  def ui_test_scheme
    ui_test_scheme = "#{scheme}UITests"
    return File.directory?("#{@path}/#{ui_test_scheme}") && Dir["#{@path}/#{ui_test_scheme}/*"].length > 1 ? ui_test_scheme : nil
  end

  def unit_test_scheme
    unit_test_scheme = "#{scheme}Tests"
    return File.directory?("#{@path}/#{unit_test_scheme}") ? unit_test_scheme : nil
  end
  
  def workspace
    workspace_path = "#{@path}/#{scheme}.xcworkspace"
    return File.directory?(workspace_path) ? workspace_path : nil
  end
end
