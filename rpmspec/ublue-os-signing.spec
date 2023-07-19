Name:           ublue-os-signing
Packager:       ublue-os
Vendor:         ublue-os
Version:        0.1
Release:        1%{?dist}
Summary:        Signing files and keys for Universal Blue
License:        MIT
URL:            https://github.com/ublue-os/config

BuildArch:      noarch

Source0:        ublue-os-signing.tar.gz

%global sub_name %{lua:t=string.gsub(rpm.expand("%{NAME}"), "^ublue%-os%-", ""); print(t)}

%description
Adds files and keys for signing Universal Blue images

%prep
%setup -q -c -T

%build
mkdir -p -m0755 %{buildroot}%{_datadir}/%{VENDOR}
mkdir -p -m0755 %{buildroot}%{_exec_prefix}/etc/containers/registries.d
mkdir -p -m0755 %{buildroot}%{_exec_prefix}/etc/pki/containers

tar xf %{SOURCE0} -C %{buildroot}%{_datadir}/%{VENDOR} --strip-components=1
tar xf %{SOURCE0} -C %{buildroot} --strip-components=2

%files
%dir %attr(0755,root,root) %{_datadir}/%{VENDOR}/%{sub_name}
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/etc/containers/policy.json
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/etc/containers/registries.d/ublue-os.yaml
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/etc/pki/containers/ublue-os.pub
%attr(0644,root,root) %{_exec_prefix}/etc/containers/policy.json
%attr(0644,root,root) %{_exec_prefix}/etc/containers/registries.d/ublue-os.yaml
%attr(0644,root,root) %{_exec_prefix}/etc/pki/containers/ublue-os.pub

%changelog
* Mon Jul 17 2023 RJ Trujillo <eyecantcu@pm.me> - 0.1
- Add package for signing files and keys
