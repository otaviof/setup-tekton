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
