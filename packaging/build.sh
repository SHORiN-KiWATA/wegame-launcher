#!/bin/bash
# 构建安装包：packaging/build.sh <deb|rpm|arch> <版本>
# 产物放在 dist/。启动器是一个 Python 脚本，不用按发行版分别编译：
# deb 是 all 架构（Debian 13+、Ubuntu 24.04+ 通用），rpm 是 noarch（Fedora）。
set -euo pipefail

kind=$1 version=$2
pkg=wegame-launcher
root=$(cd "$(dirname "$0")/.." && pwd)
dist=$root/dist
mkdir -p "$dist"
cd "$root"

case "$kind" in
deb)
    stage=$(mktemp -d)
    chmod 755 "$stage"
    install -Dm755 wegame-launcher -t "$stage/usr/bin"
    install -Dm644 wegame-launcher.desktop -t "$stage/usr/share/applications"
    install -Dm644 wegame.png "$stage/usr/share/icons/hicolor/256x256/apps/wegame.png"
    install -Dm644 README.md -t "$stage/usr/share/doc/$pkg"
    install -Dm644 LICENSE "$stage/usr/share/doc/$pkg/copyright"
    mkdir -p "$stage/DEBIAN"
    # Proton 不经过 Steam 运行时直接运行，Wine 运行时加载的库由系统提供：
    # X11（显示）、freetype/fontconfig（文字）、gnutls（HTTPS）、Vulkan（DXVK）是 WeGame 必需的。
    cat > "$stage/DEBIAN/control" <<CTRL
Package: $pkg
Version: $version-1
Architecture: all
Maintainer: SHORiN-KiWATA <fcl709@outlook.com>
Installed-Size: $(du -sk --exclude=DEBIAN "$stage" | cut -f1)
Depends: python3 (>= 3.12), python3-gi, gir1.2-gtk-4.0 (>= 4.10), ca-certificates,
 libx11-6, libxext6, libxrandr2, libxrender1, libxi6, libxcursor1, libxinerama1,
 libxcomposite1, libxfixes3, libxxf86vm1, libfreetype6, libfontconfig1,
 libgnutls30t64 | libgnutls30, libvulkan1
Recommends: mesa-vulkan-drivers | vulkan-icd, libgl1, libegl1, libpulse0, xdg-utils, 7zip | p7zip-full
Suggests: gamescope, mangohud
Section: games
Priority: optional
Homepage: https://github.com/SHORiN-KiWATA/wegame-launcher
Description: Install and run Tencent WeGame with Proton
 A small GTK launcher that installs the official WeGame offline package into
 its own Wine prefix and runs it with WE-Proton, a Proton fork that fixes
 WeGame's problems under Wine. WE-Proton is downloaded automatically when it
 is not installed. Open "WeGame 启动器" from the application menu.
CTRL
    dpkg-deb --root-owner-group --build "$stage" "$dist/${pkg}_${version}-1_all.deb"
    rm -rf "$stage"
    ;;
rpm)
    top=$(mktemp -d)
    mkdir -p "$top"/{SOURCES,SPECS,BUILD,RPMS,SRPMS}
    tar --exclude=./.git --exclude=./dist --transform "s,^\.,$pkg-$version," \
        -czf "$top/SOURCES/$pkg-$version.tar.gz" .
    rpmbuild -bb --define "_topdir $top" --define "_ver $version" packaging/rpm/$pkg.spec
    find "$top/RPMS" -name '*.rpm' -exec cp {} "$dist/" \;
    rm -rf "$top"
    ;;
arch)
    chown -R builder: "$root"
    su builder -c "cd '$root/packaging/arch' && WEGAME_LAUNCHER_VERSION='$version' makepkg -f -d --noconfirm"
    find packaging/arch -maxdepth 1 -name '*.pkg.tar.zst' -exec cp {} "$dist/" \;
    ;;
*)
    echo "unknown kind: $kind" >&2; exit 1 ;;
esac

ls -l "$dist"
