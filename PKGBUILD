# Maintainer: SHORiN-KiWATA <161345689+SHORiN-KiWATA@users.noreply.github.com>

pkgname=wegame-launcher
pkgver=0.1.0
pkgrel=1
pkgdesc='Standalone launcher that installs and runs Tencent WeGame with Proton (unofficial)'
arch=('x86_64')
url='https://github.com/SHORiN-KiWATA/wegame-launcher'
license=('GPL-3.0-only')
# The launcher itself is plain Python + GTK 4. Everything else (DW-Proton,
# WeGame, 7-Zip when missing) it downloads at runtime into ~/.wegame-launcher.
depends=('python' 'python-gobject' 'gtk4')
# Proton runs outside the Steam runtime, so the host provides what Wine loads.
# WeGame is 32-bit but runs in Wine's WoW64 mode, so 64-bit libraries suffice.
depends+=(
  'freetype2' 'fontconfig'
  'gnutls'          # Wine's TLS; WeGame is all HTTPS
  'libx11' 'libxext' 'libxrandr' 'libxi' 'libxcursor'
  'libxcomposite' 'libxinerama' 'libxrender' 'libxxf86vm'
  'vulkan-icd-loader'
  'libpulse'
)
optdepends=(
  'vulkan-driver: DXVK rendering (WeGame does not start without Vulkan)'
  'dwproton-bin: use a system-wide DW-Proton instead of downloading one'
  '7zip: use the system 7z instead of downloading 7-Zip'
  'gamescope: run WeGame nested in its own compositor'
  'mangohud: performance overlay'
  'xdg-utils: open the prefix folder'
)
source=("$pkgname-$pkgver.tar.gz::$url/archive/refs/tags/v$pkgver.tar.gz")
sha256sums=('SKIP')  # run updpkgsums once the v$pkgver tag exists

package() {
  cd "$pkgname-$pkgver"
  install -Dm755 wegame-launcher -t "$pkgdir/usr/bin"
  install -Dm644 wegame-launcher.desktop -t "$pkgdir/usr/share/applications"
}
