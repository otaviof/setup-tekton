#
# Enviroment Variables with Default Values
#

# namespace name for the container registry
readonly export REGISTRY_NAMESPACE="${REGISTRY_NAMESPACE:-registry}"
# the container registry uses the internal k8s service hosntame
readonly export REGISTRY_HOSTNAME="${REGISTRY_HOSTNAME:-registry.registry.svc.cluster.local}"

# namespace name for Tekton Pipeline controller
readonly export TEKTON_NAMESPACE="${TEKTON_NAMESPACE:-tekton-pipelines}"

# timeout employed during rollout status and deployments in general
readonly export DEPLOYMENT_TIMEOUT="${DEPLOYMENT_TIMEOUT:-3m}"

#
# Helper Functions
#

# print error message and exit on error.
function fail() {
	echo "ERROR: ${*}" >&2
	exit 1
}

# print out a strutured message.
function phase() {
	echo "---> Phase: ${*}..."
}

# uses kubectl to check the deployment status on namespace and name informed.
function rollout_status() {
	local namespace="${1}"
	local deployment="${2}"

	if ! kubectl --namespace="${namespace}" --timeout=${DEPLOYMENT_TIMEOUT} \
			rollout status deployment "${deployment}"; then
		fail "'${namespace}/${deployment}' is not deployed as expected!"
	fi
}

# inspect the path after the informed executable name.
function probe_bin_on_path() {
	local name="${1}"

	if ! type -a ${name} >/dev/null 2>&1; then
		fail "Can't find '${name}' on 'PATH=${PATH}'"
	fi
}