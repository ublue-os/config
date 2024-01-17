#!/usr/bin/bash

set -ouex pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mkdir -p /tmp/ublue-os/rpmbuild/SOURCES

cp ${SCRIPT_DIR}/*.just /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/ublue-os-just.sh /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/ujust /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/ugum /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/lib-ujust/ujust.sh /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/lib-ujust/libcolors.sh /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/lib-ujust/libformatting.sh /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/lib-ujust/libfunctions.sh /tmp/ublue-os/rpmbuild/SOURCES
cp ${SCRIPT_DIR}/lib-ujust/libdistrobox.sh /tmp/ublue-os/rpmbuild/SOURCES

rpmbuild -ba \
    --define '_topdir /tmp/ublue-os/rpmbuild' \
    --define '%_tmppath %{_topdir}/tmp' \
    ${SCRIPT_DIR}/ublue-os-just.spec
