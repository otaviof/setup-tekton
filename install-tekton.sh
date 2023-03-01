#!/usr/bin/env bash
#
# Installs Tekton Pipelines using the first argument as target version.
#

shopt -s inherit_errexit
set -eu -o pipefail

source "$(dirname ${BASH_SOURCE[0]})/common.sh"
source "$(dirname ${BASH_SOURCE[0]})/inputs.sh"

readonly tekton_host_path="tektoncd/pipeline/releases/download"

phase "Deploying Tekton Pipelines '${INPUT_TEKTON_VERSION}'"

kubectl apply -f "https://github.com/${tekton_host_path}/${INPUT_TEKTON_VERSION}/release.yaml"

phase "Waiting for Tekton components"

rollout_status "${TEKTON_NAMESPACE}" "tekton-pipelines-controller"
rollout_status "${TEKTON_NAMESPACE}" "tekton-pipelines-webhook"

phase "Setting up the feature-flag(s): '${INPUT_FEATURE_FLAGS}"
if [ "${INPUT_FEATURE_FLAGS}" != "{}" ]; then
	kubectl patch configmap/feature-flags \
		--namespace="${TEKTON_NAMESPACE}" \
		--type=merge \
		--patch="{ \"data\": ${INPUT_FEATURE_FLAGS} }"

	# after patching the feature flags, making sure the rollout is not progressing again
	rollout_status "${TEKTON_NAMESPACE}" "tekton-pipelines-controller"
	rollout_status "${TEKTON_NAMESPACE}" "tekton-pipelines-webhook"
fi
