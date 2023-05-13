Name:           ublue-os-udev-rules
Packager:       ublue-os
Vendor:         ublue-os
Version:        0.4
Release:        1%{?dist}
Summary:        Additional udev files for device support

License:        MIT
URL:            https://github.com/ublue-os/udev-rules

BuildArch:      noarch
Supplements:    systemd-udev

Source0:        ublue-os-udev-rules.tar.gz
Source1:        game-devices-udev.tar.gz

%global sub_name %{lua:t=string.gsub(rpm.expand("%{NAME}"), "^ublue%-os%-", ""); print(t)}

%description
Adds various udev rules for improving device support

%prep
%setup -q -c -T

%install
mkdir -p -m0755 %{buildroot}%{_datadir}/%{VENDOR}/{%{sub_name},game-devices-udev}

tar xf %{SOURCE0} -C %{buildroot}%{_datadir}/%{VENDOR} --strip-components=1
tar xzf %{SOURCE1} -C %{buildroot}%{_datadir}/%{VENDOR}/game-devices-udev --strip-components=1

mkdir -p -m0755 %{buildroot}%{_exec_prefix}/lib/udev/rules.d

cp %{buildroot}%{_datadir}/%{VENDOR}/{%{sub_name}/etc/udev/rules.d,game-devices-udev}/*.rules %{buildroot}%{_exec_prefix}/lib/udev/rules.d

%files
%dir %attr(0755,root,root) %{_datadir}/%{VENDOR}/%{sub_name}
%dir %attr(0755,root,root) %{_datadir}/%{VENDOR}/game-devices-udev
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/etc/udev/rules.d/*.rules
%attr(0644,root,root) %{_datadir}/%{VENDOR}/game-devices-udev/*.rules
%attr(0644,root,root) %{_datadir}/%{VENDOR}/game-devices-udev/README.md
%attr(0644,root,root) %{_datadir}/%{VENDOR}/game-devices-udev/LICENSE
%attr(0644,root,root) %{_datadir}/%{VENDOR}/game-devices-udev/game-controller-udev.svg
%attr(0644,root,root) %{_datadir}/%{VENDOR}/game-devices-udev/8BitDo.md
%attr(0644,root,root) %{_exec_prefix}/lib/udev/rules.d/*.rules


%changelog
* Thu May 13 2023 Benjamin Sherman <benjamin@holyarmy.org> - 0.4
- Add usb-realtek-net rules

* Fri May 12 2023 Benjamin Sherman <benjamin@holyarmy.org> - 0.3
- Refactor directory structure
- Adjust RPM description

* Fri Mar 03 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.2
- Add game-devices-udev rules

* Sat Feb 25 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.1
- Add game-devices-udev rules
