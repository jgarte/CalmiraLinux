#!/bin/bash
# CBuild - автоматизированная система сборки Calmira GNU/Linux
#
# (C) 2021 Michail Krasnov <linuxoid85@gmail.com>
#

CALM=/mnt/calm

mount -v --bind /dev $CALM/dev
mount -v --bind /dev/pts $CALM/dev/pts
mount -vt proc proc $CALM/proc
mount -vt sysfs sysfs $CALM/sys
mount -vt tmpfs tmpfs $CALM/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $CALM/$(readlink $CALM/dev/shm)
fi

echo r10.1-92 > $CALM/etc/lfs-release

cat > $CALM/etc/lsb-release << "EOF"
DISTRIB_ID="Calmira GNU/Linux"
DISTRIB_RELEASE="2022.1"
DISTRIB_CODENAME="Cassiopeia"
DISTRIB_DESCRIPTION="Calmira 2022.1 GNU/Linux"
EOF

cat > $CALM/etc/os-release << "EOF"
NAME="Calmira GNU/Linux"
VERSION="2022.1"
ID=calmira
PRETTY_NAME="Calmira GNU/Linux 2022.1"
VERSION_CODENAME="Cassiopeia"
EOF

mksquashfs $CALM calmira_2022.1.sqsh





