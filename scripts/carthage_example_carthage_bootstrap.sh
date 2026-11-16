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

info "Resolving SPM packages as a workaround for Cartahge timeouts..."
xcodebuild -resolvePackageDependencies -project "${judo_kit_dir}/Examples/SPMExampleApp/SPMExampleApp.xcodeproj" -scheme SPMExampleApp

# Execute carthage bootstrap
info "Executing carthage bootstrap..."

cd "${carthage_example_app_dir}" || error "Executing \`cd\` failed"

# Some dependencies (e.g. TrustKit) still target iOS 12, which current Xcode versions no longer
# build for (the minimum is iOS 15). Raise the deployment target for the Carthage builds only.
carthage_xcconfig="$(mktemp -t carthage_example)"
trap 'rm -f "${carthage_xcconfig}"' EXIT
echo "IPHONEOS_DEPLOYMENT_TARGET = 15.0" > "${carthage_xcconfig}"
export XCODE_XCCONFIG_FILE="${carthage_xcconfig}"

carthage bootstrap --platform ios --use-xcframeworks --cache-builds

carthage_exit_code="$?"

if [[ "${carthage_exit_code}" != 0 ]]; then
  error "Executing carthage bootstrap failed with status code: ${carthage_exit_code}"
fi

info "Done!"
