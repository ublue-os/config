FROM registry.fedoraproject.org/fedora:latest AS builder

RUN dnf install --disablerepo='*' --enablerepo='fedora,updates' --setopt install_weak_deps=0 --nodocs --assumeyes rpm-build

ADD https://gitlab.com/jntesteves/game-devices-udev/-/archive/main/game-devices-udev-main.tar.gz /tmp/ublue-os/rpmbuild/SOURCES/game-devices-udev.tar.gz

ADD etc /tmp/ublue-os-udev-rules/etc
RUN tar cf /tmp/ublue-os/rpmbuild/SOURCES/ublue-os-udev-rules.tar.gz -C /tmp ublue-os-udev-rules

ADD ublue-os-udev-rules.spec /tmp/ublue-os/ublue-os-udev-rules.spec

RUN rpmbuild -ba \
    --define '_topdir /tmp/ublue-os/rpmbuild' \
    --define '%_tmppath %{_topdir}/tmp' \
    /tmp/ublue-os/ublue-os-udev-rules.spec

RUN mkdir /tmp/ublue-os/ublue-os-udev-rules
RUN rpm2cpio /tmp/ublue-os/rpmbuild/RPMS/noarch/ublue-os-udev-rules-*.noarch.rpm | cpio -idmv --directory /tmp/ublue-os/ublue-os-udev-rules

FROM scratch

COPY --from=builder /tmp/ublue-os/ublue-os-udev-rules /ublue-os-udev-rules
COPY --from=builder /tmp/ublue-os/rpmbuild/RPMS/noarch/ublue-os-udev-rules-*.noarch.rpm  /ublue-os-udev-rules.noarch.rpm
