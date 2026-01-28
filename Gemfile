source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'cocoapods'
gem 'fastlane'

# temporary workaround: https://github.com/fastlane/fastlane/issues/21794#issuecomment-2102563823
gem 'rb-readline'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)

gem "standardrb", "~> 1.0"

gem "slather", "~> 2.8"
