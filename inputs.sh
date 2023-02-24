#
# GitHub Action Inputs
#

set -a

readonly export INPUT_TEKTON_VERSION="${INPUT_TEKTON_VERSION:-}"
readonly export INPUT_CLI_VERSION="${INPUT_CLI_VERSION:-}"
readonly export INPUT_FEATURE_FLAGS="${INPUT_FEATURE_FLAGS:-}"

[[ -z "${INPUT_TEKTON_VERSION}" ]] && \
	fail "INPUT_TEKTON_VERSION environment variable is not set!"

[[ -z "${INPUT_FEATURE_FLAGS}" ]] && \
	fail "INPUT_FEATURE_FLAGS environment variable is not set!"

[[ -z "${INPUT_CLI_VERSION}" ]] && \
	fail "INPUT_CLI_VERSION environment variable is not set!"

# path to the current workspace
readonly export GITHUB_WORKSPACE="${GITHUB_WORKSPACE:-.}"
# name of the organization and repository, joined by slash
readonly export GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-}"
