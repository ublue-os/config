Name:           ublue-os-just
Packager:       ublue-os
Vendor:         ublue-os
Version:        0.1
Release:        1%{?dist}
Summary:        ublue-os just integration
License:        MIT
URL:            https://github.com/ublue-os/config

BuildArch:      noarch
Supplements:    just

Source0:        justfile
Source1:        ublue-os-just.sh

%description
Adds ublue-os just integration for easier setup

%prep
%setup -q -c -T

%build

mkdir -p -m0755  %{buildroot}%{_datadir}/%{VENDOR}/%{NAME}
cp %{SOURCE0} %{SOURCE1} %{buildroot}%{_datadir}/%{VENDOR}/%{NAME}
install -Dm755 %{SOURCE1}  %{buildroot}%{_sysconfdir}/profile.d/ublue-os-just.sh

%files
%dir %attr(0755,root,root) %{_datadir}/%{VENDOR}/%{NAME}
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{NAME}/justfile
%attr(0755,root,root) %{_datadir}/%{VENDOR}/%{NAME}/ublue-os-just.sh
%attr(0755,root,root) %{_sysconfdir}/profile.d/ublue-os-just.sh

%changelog
* Sun Mar 05 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.1
- Add justfile integration
