#!/usr/bin/bash

set -ouex pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mkdir -p /tmp/ublue-os/rpmbuild/SOURCES

cp ${SCRIPT_DIR}/{custom,main,nvidia}.just /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/ublue-os-just.sh /tmp/ublue-os/rpmbuild/SOURCES

rpmbuild -ba \
    --define '_topdir /tmp/ublue-os/rpmbuild' \
    --define '%_tmppath %{_topdir}/tmp' \
    ${SCRIPT_DIR}/ublue-os-just.spec
