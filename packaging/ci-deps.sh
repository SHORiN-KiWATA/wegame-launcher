#!/bin/sh
# 在 CI 容器里安装打包工具：packaging/ci-deps.sh <deb|rpm|arch>
set -eu
case "$1" in
    deb)
        export DEBIAN_FRONTEND=noninteractive
        apt-get update
        apt-get install -y --no-install-recommends dpkg-dev ;;
    rpm)
        dnf install -y rpm-build tar gzip ;;
    arch)
        pacman -Syu --noconfirm --needed base-devel
        id builder >/dev/null 2>&1 || useradd -m builder ;;
    *) echo "unknown kind: $1" >&2; exit 1 ;;
esac
