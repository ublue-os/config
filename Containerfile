FROM registry.fedoraproject.org/fedora:latest AS builder

RUN dnf install --disablerepo='*' --enablerepo='fedora,updates' --setopt install_weak_deps=0 --nodocs --assumeyes rpm-build systemd-rpm-macros

ADD https://codeberg.org/fabiscafe/game-devices-udev/archive/main.tar.gz /tmp/ublue-os/rpmbuild/SOURCES/game-devices-udev.tar.gz

ADD files/etc/udev/rules.d /tmp/ublue-os/udev-rules/etc/udev/rules.d
ADD files/usr/lib/systemd /tmp/ublue-os/update-services/usr/lib/systemd
ADD files/etc/rpm-ostreed.conf /tmp/ublue-os/update-services/etc/rpm-ostreed.conf
ADD files/usr/etc /tmp/ublue-os/signing/usr/etc

RUN tar cf /tmp/ublue-os/rpmbuild/SOURCES/ublue-os-udev-rules.tar.gz -C /tmp ublue-os/udev-rules
RUN tar cf /tmp/ublue-os/rpmbuild/SOURCES/ublue-os-update-services.tar.gz -C /tmp ublue-os/update-services
RUN tar cf /tmp/ublue-os/rpmbuild/SOURCES/ublue-os-signing.tar.gz -C /tmp ublue-os/signing

ADD rpmspec/*.spec /tmp/ublue-os

RUN rpmbuild -ba \
    --define '_topdir /tmp/ublue-os/rpmbuild' \
    --define '%_tmppath %{_topdir}/tmp' \
    /tmp/ublue-os/*.spec
    
#This can be cleaner and put together with other RPMs in -config, I cant be bothered right now    
ADD build /tmp/build
RUN /tmp/build/ublue-os-just/build.sh

RUN mkdir /tmp/ublue-os/{files,rpms}

# Dump a file list for each RPM for easier consumption
RUN \
    for RPM in /tmp/ublue-os/rpmbuild/RPMS/*/*.rpm; do \
        NAME="$(rpm -q $RPM --queryformat='%{NAME}')"; \
        mkdir "/tmp/ublue-os/files/${NAME}"; \
        rpm2cpio "${RPM}" | cpio -idmv --directory "/tmp/ublue-os/files/${NAME}"; \
        cp "${RPM}" "/tmp/ublue-os/rpms/$(rpm -q "${RPM}" --queryformat='%{NAME}.%{ARCH}.rpm')"; \
    done

FROM scratch

# Copy build RPMs
COPY --from=builder /tmp/ublue-os/rpms /rpms
# Copy dumped RPM content
COPY --from=builder /tmp/ublue-os/files /files
