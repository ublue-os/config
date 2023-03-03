Name:           ublue-os-udev-rules
Packager:       ublue-os
Vendor:         ublue-os
Version:        0.2
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
mkdir -p -m0755 %{buildroot}%{_datadir}/%{VENDOR}/{%{NAME},game-devices-udev}

tar xf %{SOURCE0} -C %{buildroot}%{_datadir}/%{VENDOR}
tar xzf %{SOURCE1} -C %{buildroot}%{_datadir}/%{VENDOR}/game-devices-udev --strip-components=1

mkdir -p -m0755 %{buildroot}%{_exec_prefix}/lib/udev/rules.d

cp %{buildroot}%{_datadir}/%{VENDOR}/{%{NAME}/etc/udev/rules.d,game-devices-udev}/*.rules %{buildroot}%{_exec_prefix}/lib/udev/rules.d

%files
%dir %attr(0755,root,root) %{_datadir}/%{VENDOR}/%{NAME}
%dir %attr(0755,root,root) %{_datadir}/%{VENDOR}/game-devices-udev
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{NAME}/etc/udev/rules.d/*.rules
%attr(0644,root,root) %{_datadir}/%{VENDOR}/game-devices-udev/*.rules
%attr(0644,root,root) %{_datadir}/%{VENDOR}/game-devices-udev/README.md
%attr(0644,root,root) %{_datadir}/%{VENDOR}/game-devices-udev/LICENSE
%attr(0644,root,root) %{_datadir}/%{VENDOR}/game-devices-udev/game-controller-udev.svg
%attr(0644,root,root) %{_exec_prefix}/lib/udev/rules.d/*.rules


%changelog
* Fri Mar 03 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.2
- Add game-devices-udev rules

* Sat Feb 25 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.1
- Add game-devices-udev rules
