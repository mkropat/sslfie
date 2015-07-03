# sslfie.spec: specification for building the .rpm file

# Generated with: rpmdev-newspec sslfie

Name:           sslfie
Version:        %{VERSION}
Release:        1%{?dist}
Summary:        generate self-signed x.509 certificates for use with SSL/TLS

License:        MIT
URL:            https://github.com/mkropat/sslfie
Source0:        %{name}_%{version}.tar.bz2

BuildArch:      noarch
BuildRequires:	pandoc
Requires:       openssl

%description
- Supports multiple domain names in one cert with the SubjectAltName field
- Trivial to automate — the only required argument is a domain name

%prep
%setup -q

%build
make

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=%{buildroot} PREFIX=/usr install
mkdir -p %{buildroot}%{_unitdir}

%files
%{_bindir}/*
%{_mandir}/man1/*

%changelog
* Fri Jul 3 2015 Michael Kropat <mail@michael.kropat.name> - 0.1-1
- Initial release
