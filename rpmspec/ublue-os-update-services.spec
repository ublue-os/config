Name:           ublue-os-update-services
Packager:       ublue-os
Vendor:         ublue-os
Version:        0.4
Release:        1%{?dist}
Summary:        Automatic updates for rpm-ostree and flatpak
License:        MIT
URL:            https://github.com/ublue-os/config

BuildArch:      noarch
BuildRequires:  systemd-rpm-macros
Supplements:    rpm-ostree flatpak

Source0:        ublue-os-update-services.tar.gz

%global sub_name %{lua:t=string.gsub(rpm.expand("%{NAME}"), "^ublue%-os%-", ""); print(t)}

%description
Adds systemd units and configuration files for enabling automatic updates in rpm-ostree and flatpak

%prep
%setup -q -c -T

%build

mkdir -p -m0755 %{buildroot}%{_datadir}/%{VENDOR}

tar xf %{SOURCE0} -C %{buildroot}%{_datadir}/%{VENDOR} --strip-components=1

# rpm-ostreed.conf cannot be installed in /etc as it'd conflict with upstream 
# rpm-ostree package
tar xf %{SOURCE0} -C %{buildroot} --strip-components=2 --exclude etc/rpm-ostreed.conf


%post
%systemd_post flatpak-system-update.timer
%systemd_user_post flatpak-user-update.timer


%preun
%systemd_preun flatpak-system-update.timer
%systemd_user_preun flatpak-user-update.timer


%files
%dir %attr(0755,root,root) %{_datadir}/%{VENDOR}/%{sub_name}
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/lib/systemd/system-preset/10-flatpak-system-update.preset
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/lib/systemd/system/flatpak-system-update.service
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/lib/systemd/system/flatpak-system-update.timer
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/lib/systemd/user-preset/10-flatpak-user-update.preset
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/lib/systemd/user/flatpak-user-update.service
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/lib/systemd/user/flatpak-user-update.timer
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/%{_sysconfdir}/rpm-ostreed.conf
%attr(0644,root,root) %{_exec_prefix}/lib/systemd/system-preset/10-flatpak-system-update.preset
%attr(0644,root,root) %{_exec_prefix}/lib/systemd/system/flatpak-system-update.service
%attr(0644,root,root) %{_exec_prefix}/lib/systemd/system/flatpak-system-update.timer
%attr(0644,root,root) %{_exec_prefix}/lib/systemd/user-preset/10-flatpak-user-update.preset
%attr(0644,root,root) %{_exec_prefix}/lib/systemd/user/flatpak-user-update.service
%attr(0644,root,root) %{_exec_prefix}/lib/systemd/user/flatpak-user-update.timer


%changelog
* Fri Jun 30 2023 gerblesh <101901964+gerblesh@users.noreply.github.com> - 0.4
- Add BuildRequires for rpm-systemd-macros to fix enabling systemd services and uninstalling the RPM

* Fri May 12 2023 Benjamin Sherman <benjamin@holyarmy.org> - 0.4
- Refactor directory structure

* Fri Mar 03 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.3
- Enable timers for flatpak update services

* Fri Mar 03 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.2
- Add presets for flatpak update services

* Fri Mar 03 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.1
- Add flatpak update service and rpm-ostree config file
