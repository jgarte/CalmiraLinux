#!/bin/bash
# Скрипт для автоматизации входа в chroot уже собранной системы
# (C) 2021 Михаил Краснов <linuxoid85@gmail.com>
# Для Calmira LX4 1.1 (2021.5)

## SYNOPSIS
# calm-chroot DISK

export LIN=/mnt/lin

mkdir -pv $LIN
mount -v $1 $LIN

mount -v --bind /dev $LIN/dev
mount -v --bind /dev/pts $LIN/dev/pts
mount -vt proc proc $LIN/proc
mount -vt sysfs sysfs $LIN/sys
mount -vt tmpfs tmpfs $LIN/run

if [ -h $LIN/dev/shm ]; then
  mkdir -pv $LIN/$(readlink $LIN/dev/shm)
fi

chroot "$LIN" /usr/bin/env -i \
    HOME=/root TERM="$TERM"   \
    PS1='(chroot) \u:\w\$ '   \
    PATH=/usr/bin             \
    /bin/bash --login
