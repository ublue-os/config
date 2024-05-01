#!/usr/bin/bash

set -ouex pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mkdir -p /tmp/ublue-os/rpmbuild/SOURCES

cp ${SCRIPT_DIR}/*.just /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/ujust /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/ugum /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/lib-ujust/*.sh /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/etc-distrobox/*.ini /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/etc-profile.d/ublue-os-just.sh /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/etc-profile.d/user-motd.sh /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/etc-profile.d/brew.sh /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/etc-toolbox/toolbox.ini /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/ublue-tips/*.md /tmp/ublue-os/rpmbuild/SOURCES

rpmbuild -ba \
    --define '_topdir /tmp/ublue-os/rpmbuild' \
    --define '%_tmppath %{_topdir}/tmp' \
    ${SCRIPT_DIR}/ublue-os-just.spec
