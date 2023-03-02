Name:           ublue-os-udev-rules
Version:        0.1
Release:        1%{?dist}
Summary:        Additional udev files for game controller support

License:        MIT
URL:            https://github.com/ublue-os/udev-rules

BuildArch:      noarch
Supplements:    systemd-udev

Source0:        ublue-os-udev-rules.tar.gz
Source1:        game-devices-udev.tar.gz

%description
Adds various udev rules for improving game controller support

%prep
%setup -q -c -T

%install
mkdir -p -m0755 %{buildroot}%{_datadir}/ublue-os/{ublue-os-udev-rules,game-devices-udev}

tar xf %{SOURCE0} -C %{buildroot}%{_datadir}/ublue-os
tar xzf %{SOURCE1} -C %{buildroot}%{_datadir}/ublue-os/game-devices-udev --strip-components=1

mkdir -p -m0755 %{buildroot}%{_exec_prefix}/lib/udev/rules.d

cp %{buildroot}%{_datadir}/ublue-os/{ublue-os-udev-rules/etc/udev/rules.d,game-devices-udev}/*.rules %{buildroot}%{_exec_prefix}/lib/udev/rules.d

%files
%dir %attr(0755,root,root) %{_datadir}/ublue-os/ublue-os-udev-rules
%dir %attr(0755,root,root) %{_datadir}/ublue-os/game-devices-udev
%attr(0644,root,root) %{_datadir}/ublue-os/ublue-os-udev-rules/etc/udev/rules.d/*.rules
%attr(0644,root,root) %{_datadir}/ublue-os/game-devices-udev/*.rules
%attr(0644,root,root) %{_datadir}/ublue-os/game-devices-udev/README.md
%attr(0644,root,root) %{_datadir}/ublue-os/game-devices-udev/LICENSE
%attr(0644,root,root) %{_datadir}/ublue-os/game-devices-udev/game-controller-udev.svg
%attr(0644,root,root) %{_exec_prefix}/lib/udev/rules.d/*.rules

%changelog
* Sat Feb 25 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.1
- Add game-devices-udev rules
