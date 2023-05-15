Name:           ublue-os-just
Packager:       ublue-os
Vendor:         ublue-os
Version:        0.2
Release:        1%{?dist}
Summary:        ublue-os just integration
License:        MIT
URL:            https://github.com/ublue-os/config

BuildArch:      noarch
Supplements:    just

Source0:        ublue-os-just.sh
Source1:        custom.just
Source2:        main.just
Source3:        nvidia.just

%global sub_name %{lua:t=string.gsub(rpm.expand("%{NAME}"), "^ublue%-os%-", ""); print(t)}

%description
Adds ublue-os just integration for easier setup

%prep
%setup -q -c -T

%build

mkdir -p -m0755  %{buildroot}%{_datadir}/%{VENDOR}/%{sub_name}
cp %{SOURCE0} %{SOURCE1} %{SOURCE2} %{SOURCE3} %{buildroot}%{_datadir}/%{VENDOR}/%{sub_name}
install -Dm755 %{SOURCE0}  %{buildroot}%{_sysconfdir}/profile.d/ublue-os-just.sh

%files
%dir %attr(0755,root,root) %{_datadir}/%{VENDOR}/%{sub_name}
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/custom.just
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/main.just
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/nvidia.just
%attr(0755,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/ublue-os-just.sh
%attr(0755,root,root) %{_sysconfdir}/profile.d/ublue-os-just.sh

%changelog
* Sun May 13 2023 Benjamin Sherman <benjamin@holyarmy.org> - 0.2
- Refactor directory structure
- Rename justfile to main.just
- Add nvidia.just and custom.just
- Make profile script intelligent about including nvidia.just

* Sun Mar 05 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.1
- Add justfile integration
