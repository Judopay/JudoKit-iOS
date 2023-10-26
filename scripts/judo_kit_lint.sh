#!/bin/bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
judo_kit_dir=$(dirname "${script_dir}")

. "$script_dir/helpers.sh"

info "Linting JudoKit source files with clang-format ..."
sh "$script_dir/clang-format.sh" lint

clang_format_script_exit_code="$?"

if [[ "${clang_format_script_exit_code}" != 0 ]]; then
  error "Executing clang-format failed with status code: ${clang_format_script_exit_code}"
fi

info "Linting JudoKit source files with cocoapods ..."
bundle exec pod lib lint --no-subspecs --allow-warnings

pod_lib_lint_exit_code="$?"

if [[ "${pod_lib_lint_exit_code}" != 0 ]]; then
  error "Executing pod lib lint failed with status code: ${pod_lib_lint_exit_code}"
fi

info "All looking good ..."