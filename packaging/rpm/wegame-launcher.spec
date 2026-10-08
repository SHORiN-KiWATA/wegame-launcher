Name:           wegame-launcher
Version:        %{_ver}
Release:        1%{?dist}
Summary:        Install and run Tencent WeGame with Proton
License:        GPL-3.0-only
URL:            https://github.com/SHORiN-KiWATA/wegame-launcher
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

Requires:       python3 >= 3.12
Requires:       python3-gobject
Requires:       gtk4 >= 4.10
# Gtk-4.0.typelib needs cairo-1.0.typelib, which only gobject-introspection ships
Requires:       gobject-introspection
Requires:       ca-certificates
# Proton runs without the Steam runtime, so the libraries Wine loads at run time
# come from the system: X11 (display), freetype/fontconfig (text), gnutls (HTTPS)
# and Vulkan (DXVK) are needed by WeGame.
Requires:       libX11.so.6()(64bit)
Requires:       libXext.so.6()(64bit)
Requires:       libXrandr.so.2()(64bit)
Requires:       libXrender.so.1()(64bit)
Requires:       libXi.so.6()(64bit)
Requires:       libXcursor.so.1()(64bit)
Requires:       libXinerama.so.1()(64bit)
Requires:       libXcomposite.so.1()(64bit)
Requires:       libXfixes.so.3()(64bit)
Requires:       libXxf86vm.so.1()(64bit)
Requires:       libfreetype.so.6()(64bit)
Requires:       libfontconfig.so.1()(64bit)
Requires:       libgnutls.so.30()(64bit)
Requires:       libvulkan.so.1()(64bit)
Recommends:     mesa-vulkan-drivers
Recommends:     libGL.so.1()(64bit)
Recommends:     libEGL.so.1()(64bit)
Recommends:     libpulse.so.0()(64bit)
Recommends:     xdg-utils
Recommends:     7zip
Suggests:       gamescope
Suggests:       mangohud

%description
A small GTK launcher that installs the official WeGame offline package into
its own Wine prefix and runs it with WE-Proton, a Proton fork that fixes
WeGame's problems under Wine. WE-Proton and the Steam Linux Runtime it runs
in are downloaded automatically when they are not installed. Open "WeGame 启动器" from the application menu.

%prep
%autosetup

%build

%install
install -Dm755 wegame-launcher -t %{buildroot}%{_bindir}
install -Dm644 wegame-launcher.desktop -t %{buildroot}%{_datadir}/applications
install -Dm644 wegame.png %{buildroot}%{_datadir}/icons/hicolor/256x256/apps/wegame.png

%files
%license LICENSE
%doc README.md
%{_bindir}/wegame-launcher
%{_datadir}/applications/wegame-launcher.desktop
%{_datadir}/icons/hicolor/256x256/apps/wegame.png

%changelog
* Thu Oct 08 2026 SHORiN-KiWATA <fcl709@outlook.com> - %{version}-1
- See https://github.com/SHORiN-KiWATA/wegame-launcher/releases
