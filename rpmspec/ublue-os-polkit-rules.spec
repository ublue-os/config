Name:           ublue-os-polkit-rules
Packager:       ublue-os
Vendor:         ublue-os
Version:        0.1
Release:        1%{?dist}
Summary:        Additional polkit rules

License:        MIT
URL:            https://github.com/ublue-os/config

BuildArch:      noarch
Supplements:    systemd-udev

Source0:        ublue-os-polkit-rules.tar.gz

%global sub_name %{lua:t=string.gsub(rpm.expand("%{NAME}"), "^ublue%-os%-", ""); print(t)}

%description
Adds various polkit rules for improving device support

%prep
%setup -q -c -T

%install
tar xf %{SOURCE0} -C %{buildroot}%{_datadir}/%{VENDOR} --strip-components=1

mkdir -p -m0755 %{buildroot}%{_exec_prefix}/polkit-1/rules.d

cp %{buildroot}%{_datadir}/%{VENDOR}/%{sub_name}/etc/polkit-1/rules.d/*.rules %{buildroot}%{_exec_prefix}/polkit-1/rules.d

%files
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/etc/polkit-1/rules.d/*.rules

%changelog
* Sun Mar 10 2024 Justin Garrison <justin@linux.com> - 0.1
- Add polkit rules for yubikey access
