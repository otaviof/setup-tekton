#!/usr/bin/env bash
#
# Installs Tekton Pipelines using the first argument as target version.
#

shopt -s inherit_errexit
set -eu -o pipefail

source common.sh
source inputs.sh

readonly TEKTON_HOST_PATH="tektoncd/pipeline/releases/download"

phase "Deploying Tekton Pipelines '${INPUT_TEKTON_VERSION}'"

kubectl apply -f "https://github.com/${TEKTON_HOST_PATH}/${INPUT_TEKTON_VERSION}/release.yaml"

phase "Waiting for Tekton components"

rollout_status "${TEKTON_NAMESPACE}" "tekton-pipelines-controller"
rollout_status "${TEKTON_NAMESPACE}" "tekton-pipelines-webhook"

set -x
if [ "${INPUT_FEATURE_FLAGS}" != "{}" ]; then
	phase "Setting up the feature-flag(s): '${INPUT_FEATURE_FLAGS}"

	kubectl patch configmap/feature-flags \
		--namespace="${TEKTON_NAMESPACE}" \
		--type=merge \
		--patch="{ \"data\": ${INPUT_FEATURE_FLAGS} }"

	# after patching the feature flags, making sure the rollout is not progressing again
	rollout_status "${TEKTON_NAMESPACE}" "tekton-pipelines-controller"
	rollout_status "${TEKTON_NAMESPACE}" "tekton-pipelines-webhook"
fi
