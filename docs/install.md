# Установка дистрибутива

В этом разделе справки представлены инструкции по разворачиванию Calmira GNU/Linux на ПК.

## Копирование

Для того, чтобы скопировать содержимое squashfs-образа на раздел диска, вам требуется применить утилиту `unsquashfs` из состава пакета `squashfs-tools`.

```bash
sudo mkdir /mnt/calmira           # Создание точки монтирования
sudo mount /dev/sdX /mnt/calmira  # Монтирование раздела
cd /mnt/calmira

sudo unsquashfs /путь/до/образа/calmira_$VERSION_$BUILD.sqsh
```

* `$VERSION` - версия дистрибутива
* `$BUILD` - номер сборки дистрибутива

**Например:** `calmira_2021.2_build2.sqsh`

После того, как скопирована система, нужно установить загрузчик (рекомендуется сделать это из-под хост-системы, хотя можно и из самой Calmira, но могут возникнуть проблемы с установкой на UEFI).

Пример установки GRUB:
```bash
grub-install --boot-directory=/mnt/calmira/boot/grub --root-directory=/mnt/calmira /dev/sda
```

Потом создайте `grub.cfg`:
```bash
grub-mkconfig -o /mnt/calmira/boot/grub/grub.cfg
```

> Создание `grub.cfg` можно выполнить и, непосредственно, войдя в chroot скопированной системы

Завершите установку, выполнив:
```bash
mount --bind /dev /mnt/calmira/dev
mount --bind /dev/pts /mnt/calmira/dev/pts
mount --bind /proc /mnt/calmira/proc
mount --bind /sys /mnt/calmira/sys

chroot /mnt/calmira
```

Этими командами вы смонтировали виртуальные ФС ядра и вошли в chroot установленной системы. Теперь можете приступить к [настройке](setting_up.md) дистрибутива.

Помимо этого, вам придётся пересобрать ядро.
