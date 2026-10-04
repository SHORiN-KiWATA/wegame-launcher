# Maintainer: SHORiN-KiWATA <161345689+SHORiN-KiWATA@users.noreply.github.com>

pkgname=wegame-launcher
pkgver=0.1.0
pkgrel=1
pkgdesc='Standalone launcher that installs and runs Tencent WeGame with Proton (unofficial)'
arch=('any')
url='https://github.com/SHORiN-KiWATA/wegame-launcher'
license=('GPL-3.0-only')
depends=('python' 'python-gobject' 'gtk4')
optdepends=(
  'gamescope: run WeGame nested in its own compositor'
  'mangohud: performance overlay'
)
source=("$pkgname-$pkgver.tar.gz::$url/archive/refs/tags/v$pkgver.tar.gz")
sha256sums=('SKIP')  # run updpkgsums once the v$pkgver tag exists

package() {
  cd "$pkgname-$pkgver"
  install -Dm755 wegame-launcher -t "$pkgdir/usr/bin"
  install -Dm644 wegame-launcher.desktop -t "$pkgdir/usr/share/applications"
  install -Dm644 wegame.png "$pkgdir/usr/share/icons/hicolor/256x256/apps/$pkgname.png"
}
