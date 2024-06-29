Name:           ublue-os-luks
Packager:       ublue-os
Vendor:         ublue-os
Version:        0.2
Release:        1%{?dist}
Summary:        ublue-os scripts for simplified LUKS usage
License:        MIT
URL:            https://github.com/ublue-os/config

BuildArch:      noarch

Source0:        luks-disable-tpm2-autounlock
Source1:        luks-enable-tpm2-autounlock
Source2:        90-ublue-luks.conf

%description
Adds scripts and dracut config to simplify LUKS autounlock

%prep
%setup -q -c -T

%build

install -Dm755 %{SOURCE0}  %{buildroot}%{_libexecdir}/luks-disable-tpm2-autounlock
install -Dm755 %{SOURCE1}  %{buildroot}%{_libexecdir}/luks-enable-tpm2-autounlock
install -Dm644 %{SOURCE2}  %{buildroot}/%{_exec_prefix}/lib/dracut/dracut.conf.d/90-ublue-luks.conf

%files
%attr(0755,root,root) %{_libexecdir}/luks-disable-tpm2-autounlock
%attr(0755,root,root) %{_libexecdir}/luks-enable-tpm2-autounlock
%attr(0644,root,root) %{_exec_prefix}/lib/dracut/dracut.conf.d/90-ublue-luks.conf

%changelog
* Sat Jun 29 2024 Benjamin Sherman <benjamin@holyarmy.org> - 0.2
- Add tpm, fido2, pkcs11 to dracut config enabling initramfs LUKS unlock options

* Tue Apr 30 2024 Benjamin Sherman <benjamin@holyarmy.org> - 0.1
- Add tpm2 autounlock enable/disable scripts
- Original source: https://github.com/bsherman/ublue-custom/
