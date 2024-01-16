Name:           ublue-os-just
Packager:       ublue-os
Vendor:         ublue-os
Version:        0.22
Release:        1%{?dist}
Summary:        ublue-os just integration
License:        MIT
URL:            https://github.com/ublue-os/config

BuildArch:      noarch
Requires:       just

Source0:        ublue-os-just.sh
Source1:        00-default.just
Source2:        10-update.just
Source3:        20-clean.just
Source4:        30-distrobox.just
Source5:        40-nvidia.just
Source6:        50-akmods.just
Source7:        60-custom.just
Source8:        70-nix.just
Source9:        ujust
Source10:       ugum
Source11:       header.just
Source12:       ujust.sh
Source13:       libcolors.sh
Source14:       libformatting.sh
Source15:       libfunctions.sh

%global sub_name %{lua:t=string.gsub(rpm.expand("%{NAME}"), "^ublue%-os%-", ""); print(t)}

%description
Adds ublue-os just integration for easier setup

%prep
%setup -q -c -T

%build

mkdir -p -m0755  %{buildroot}%{_datadir}/%{VENDOR}/%{sub_name}
install -Dm755 %{SOURCE0}  %{buildroot}%{_sysconfdir}/profile.d/ublue-os-just.sh
cp %{SOURCE1} %{SOURCE2} %{SOURCE3} %{SOURCE4} %{SOURCE5} %{SOURCE6} %{SOURCE7} %{SOURCE8} %{buildroot}%{_datadir}/%{VENDOR}/%{sub_name}

# Create justfile which contains all .just files included in this package
# Apply header first due to default not working in included justfiles
cp %{SOURCE11} "%{buildroot}%{_datadir}/%{VENDOR}/justfile"
for justfile in %{buildroot}%{_datadir}/%{VENDOR}/%{sub_name}/*.just; do
	echo "import \"%{_datadir}/%{VENDOR}/%{sub_name}/$(basename ${justfile})\"" >> "%{buildroot}%{_datadir}/%{VENDOR}/justfile"
done

# Add global "ujust" script to run just with --unstable
mkdir -p -m0755  %{buildroot}%{_bindir}
install -Dm755 %{SOURCE9} %{buildroot}%{_bindir}/ujust
install -Dm755 %{SOURCE10} %{buildroot}%{_bindir}/ugum

# Add bash library for use in just
mkdir -p -m0755 %{buildroot}%{_libdir}/ujust/
install -Dm644 %{SOURCE12} %{buildroot}%{_libdir}/ujust
install -Dm644 %{SOURCE13} %{buildroot}%{_libdir}/ujust
install -Dm644 %{SOURCE14} %{buildroot}%{_libdir}/ujust
install -Dm644 %{SOURCE15} %{buildroot}%{_libdir}/ujust

%files
%dir %attr(0755,root,root) %{_datadir}/%{VENDOR}/%{sub_name}
%attr(0755,root,root) %{_sysconfdir}/profile.d/ublue-os-just.sh
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/*.just
%attr(0644,root,root) %{_datadir}/%{VENDOR}/justfile
%attr(0755,root,root) %{_bindir}/ujust
%attr(0755,root,root) %{_bindir}/ugum
%attr(0644,root,root) %{_libdir}/ujust/lib*.sh

%post
# Generate ujust bash completion
just --completions bash | sed -E 's/([\(_" ])just/\1ujust/g' > %{_datadir}/bash-completion/completions/ujust
chmod 644 %{_datadir}/bash-completion/completions/ujust 

%changelog
* Sun Jan 14 2024 HikariKnight <2557889+HikariKnight@users.noreply.github.com> - 0.22
- Added sourcable libraries for just recipes

* Wed Jan 10 2024 HikariKnight <2557889+HikariKnight@users.noreply.github.com> - 0.21
- Added ujust tab completion file generated from just --completions bash

* Thu Jan 04 2024 Kyle Gospodnetich <me@kylegospodneti.ch> - 0.20
- Update with support for the newest version of just

* Wed Dec 20 2023 HikariKnight <2557889+HikariKnight@users.noreply.github.com> - 0.10
- Add ugum, a helper for user input for use in just

* Tue Nov 28 2023 RJ Trujillo <eyecantcu> - 0.9
- Copy nix justfile to correct location and restore ujust

* Sat Nov 25 2023 RJ Trujillo <eyecantcu@pm.me> - 0.8
- Integrate justfile for nix

* Fri Oct 13 2023 bri <284789+b-@users.noreply.github.com> - 0.7
- Add ujust runner
- Add chsh task

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
