#!/bin/bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
judo_kit_dir=$(dirname "${script_dir}")
carthage_example_app_dir="${judo_kit_dir}/Examples/CarthageExampleApp"

. "$script_dir/helpers.sh"

# Clean carthage artifacts
info "Cleaning carthage artifacts..."

# xcodebuild clean \
#   -scheme CarthageExampleApp \
#   -project "${carthage_example_app_dir}/CarthageExampleApp.xcodeproj"

rm -f "${carthage_example_app_dir}/Cartfile"
rm -f "${carthage_example_app_dir}/Cartfile.resolved"
rm -rf "${carthage_example_app_dir}/Carthage"

# Generate new Cartfile
info "Generating new Cartfile..."

git_repo="$(cd "${carthage_example_app_dir}/../../" && pwd)"
git_hash="$(git rev-parse HEAD)"

echo "git \"${git_repo}\" \"${git_hash}\"" > "${carthage_example_app_dir}/Cartfile"

# Execute carthage bootstrap
info "Executing carthage bootstrap..."

cd "${carthage_example_app_dir}" || error "Executing \`cd\` failed"

# temporary workaround for `xcodebuild timed out while trying to read SPMExampleApp.xcodeproj`
carthage bootstrap --platform ios --no-build

info "Removing example apps files..."
rm -rf "${carthage_example_app_dir}/Carthage/Checkouts/JudoKit-iOS/Examples"

carthage build --platform ios --use-xcframeworks --cache-builds

carthage_exit_code="$?"

if [[ "${carthage_exit_code}" != 0 ]]; then
  error "Executing carthage bootstrap failed with status code: ${carthage_exit_code}"
fi

info "Done!"
