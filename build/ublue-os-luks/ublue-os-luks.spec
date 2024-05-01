Name:           ublue-os-luks
Packager:       ublue-os
Vendor:         ublue-os
Version:        0.1
Release:        1%{?dist}
Summary:        ublue-os scripts for simplified LUKS usage
License:        MIT
URL:            https://github.com/ublue-os/config

BuildArch:      noarch

Source0:        luks-disable-tpm2-autounlock
Source1:        luks-enable-tpm2-autounlock

%description
Adds scripts to simplify LUKS autounlock with TPM

%prep
%setup -q -c -T

%build

install -Dm755 %{SOURCE0}  %{buildroot}%{_libexecdir}/luks-disable-tpm2-autounlock
install -Dm755 %{SOURCE1}  %{buildroot}%{_libexecdir}/luks-enable-tpm2-autounlock

%files
%attr(0755,root,root) %{_libexecdir}/luks-disable-tpm2-autounlock
%attr(0755,root,root) %{_libexecdir}/luks-enable-tpm2-autounlock

%changelog
* Mon Apr 30 2024 Benjamin Sherman <benjamin@holyarmy.org> - 0.1
- Add tpm2 autounlock enable/disable scripts
- Original source: https://github.com/bsherman/ublue-custom/
