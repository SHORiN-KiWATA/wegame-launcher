#!/bin/sh
# 在干净的容器里安装 dist/ 下的包并做冒烟测试：packaging/smoke-test.sh <deb|rpm|arch>
# 检查依赖能装上、命令行能用、GTK 够新、图形界面能在 Xvfb 里启动且没有 Python 异常。
set -eu
cd "$(dirname "$0")/.."

case "$1" in
    deb)
        export DEBIAN_FRONTEND=noninteractive
        apt-get update
        apt-get install -y ./dist/*.deb xvfb ;;
    rpm)
        dnf install -y ./dist/*.rpm xorg-x11-server-Xvfb ;;
    arch)
        pacman -Syu --noconfirm --needed xorg-server-xvfb
        pacman -U --noconfirm dist/*.pkg.tar.zst ;;
    *) echo "unknown kind: $1" >&2; exit 1 ;;
esac

export HOME="$(mktemp -d)"
log="$HOME/gui.log"

wegame-launcher --help >/dev/null
wegame-launcher status
wegame-launcher runner

python3 - <<'EOF'
import gi
gi.require_version("Gtk", "4.0")
from gi.repository import Gtk
version = (Gtk.get_major_version(), Gtk.get_minor_version(), Gtk.get_micro_version())
print("GTK", ".".join(map(str, version)))
assert version >= (4, 10, 0), "GTK 4.10 or newer is needed (Gtk.AlertDialog)"
assert hasattr(Gtk, "AlertDialog")
EOF

Xvfb :99 -screen 0 1280x800x24 -nolisten tcp >/dev/null 2>&1 &
xvfb=$!
sleep 2
DISPLAY=:99 GSK_RENDERER=cairo wegame-launcher >"$log" 2>&1 &
gui=$!
sleep 8
status=0
if ! kill -0 "$gui" 2>/dev/null; then
    echo "the GUI exited early" >&2
    status=1
fi
if grep -q Traceback "$log"; then
    echo "the GUI raised an exception" >&2
    status=1
fi
kill "$gui" "$xvfb" 2>/dev/null || true
cat "$log"
[ "$status" = 0 ] && echo "smoke test passed"
exit "$status"
