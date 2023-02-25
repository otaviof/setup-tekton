#!/usr/bin/env bash
#
# Installs the Tekton CLI (tkn) informed version.
#

shopt -s inherit_errexit
set -eu -o pipefail

source common.sh
source inputs.sh

# the version needs to be numeric only to compose the tarball name
readonly CLI_SHORT_VERSION="${INPUT_CLI_VERSION//v/}"

readonly CLI_TARBALL="tkn_${CLI_SHORT_VERSION}_Linux_x86_64.tar.gz"
readonly CLI_HOST_PATH="tektoncd/cli/releases/download"
readonly CLI_URL="https://github.com/${CLI_HOST_PATH}/${INPUT_CLI_VERSION}/${CLI_TARBALL}"

readonly TMP_DIR="/tmp"
readonly OUTPUT_DOCUMENT="${TMP_DIR}/${CLI_TARBALL}"

phase "Installing Tekton CLI '${INPUT_CLI_VERSION}'"

# making sure the previous download is removed
[[ -f "${OUTPUT_DOCUMENT}" ]] && rm -fv ${OUTPUT_DOCUMENT}

phase "Downloading CLI tarball '${CLI_URL}'"
wget --quiet --output-document="${OUTPUT_DOCUMENT}" ${CLI_URL}
tar -C ${TMP_DIR} -zxvpf ${OUTPUT_DOCUMENT} tkn

phase "Installing the CLI"
exec install --verbose --mode=0755 "${TMP_DIR}/tkn" /usr/local/bin