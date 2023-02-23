#!/usr/bin/env bash
#
# Patches /etc/hosts to include the registry FQDN resolving to localhost.
#

set -eu -o pipefail

source common.sh
source inputs.sh

readonly ETC_HOSTS="/etc/hosts"
readonly HOSTS_ENTRY="127.0.0.1 ${INPUT_REGISTRY_HOSTNAME}"

phase "Patching '${ETC_HOSTS}' with '${HOSTS_ENTRY}' entry"
if ! grep -q "${HOSTS_ENTRY}" ${ETC_HOSTS} ; then
	echo "${HOSTS_ENTRY}" >>${ETC_HOSTS}
fi
