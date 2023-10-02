Name:           ublue-os-just
Packager:       ublue-os
Vendor:         ublue-os
Version:        0.6
Release:        1%{?dist}
Summary:        ublue-os just integration
License:        MIT
URL:            https://github.com/ublue-os/config

BuildArch:      noarch
Supplements:    just

Source0:        ublue-os-just.sh
Source1:        00-default.just
Source2:        10-update.just
Source3:        20-clean.just
Source4:        30-distrobox.just
Source5:        40-nvidia.just
Source6:        50-akmods.just
Source7:        60-custom.just

%global sub_name %{lua:t=string.gsub(rpm.expand("%{NAME}"), "^ublue%-os%-", ""); print(t)}

%description
Adds ublue-os just integration for easier setup

%prep
%setup -q -c -T

%build

mkdir -p -m0755  %{buildroot}%{_datadir}/%{VENDOR}/%{sub_name}
install -Dm755 %{SOURCE0}  %{buildroot}%{_sysconfdir}/profile.d/ublue-os-just.sh
cp %{SOURCE1} %{SOURCE2} %{SOURCE3} %{SOURCE4} %{SOURCE5} %{SOURCE6} %{SOURCE7} %{buildroot}%{_datadir}/%{VENDOR}/%{sub_name}

# Create justfile which contains all .just files included in this package
for justfile in %{buildroot}%{_datadir}/%{VENDOR}/%{sub_name}/*.just; do
	echo "!include %{_datadir}/%{VENDOR}/%{sub_name}/$(basename ${justfile})" >> "%{buildroot}%{_datadir}/%{VENDOR}/justfile"
done

%files
%dir %attr(0755,root,root) %{_datadir}/%{VENDOR}/%{sub_name}
%attr(0755,root,root) %{_sysconfdir}/profile.d/ublue-os-just.sh
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/*.just
%attr(0644,root,root) %{_datadir}/%{VENDOR}/justfile

%changelog
* Mon Oct 2 2023 ArtikusHG <24320212+ArtikusHG@users.noreply.github.com> - 0.6
- Add commands to disable and enable automatic updates to 60-updates.just

* Sat Sep 23 2023 Kyle Gospodnetich <me@kylegospodneti.ch> - 0.5
- Remove fish shell support

* Thu Sep 21 2023 Benjamin Sherman <benjamin@holyarmy.org> - 0.4
- Correct justfile include paths

* Thu Sep 21 2023 Kyle Gospodnetich <me@kylegospodneti.ch> - 0.3
- Modify just files to be numbered for ordered loading
- Move to using a single master justfile
- Clean up previous installs to point to new file
- Add support for fish shell

* Sat May 13 2023 Benjamin Sherman <benjamin@holyarmy.org> - 0.2
- Refactor directory structure
- Rename justfile to main.just
- Add nvidia.just and custom.just
- Make profile script intelligent about including nvidia.just

* Sun Mar 05 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.1
- Add justfile integration
