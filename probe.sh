#!/usr/bin/env bash
#
# Inspect the instance to make sure the dependencies needed are in place.
#

set -eu -o pipefail

source common.sh

probe_bin_on_path "kubectl"

if ! kubectl version >/dev/null 2>&1 ; then
	fail "'kubectl version' fails to report server version"
fi
