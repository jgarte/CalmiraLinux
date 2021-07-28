# Документация Calmira GNU/Linux

В данном разделе приведена документация дистрибутива Calmira GNU/Linux (текущая версия создавалась для Calmira LX4 1.1 GNU/Linux). Отсюда вы узнаете о распаковке дистрибутива из squashfs снимка, копировании на предварительно заготовленный раздел, созданию LiveUSB образа и запаковку в образ виртуального жёсткого диска для Qemu/KVM (`qcow2`).

## Содержание

### Установка дистрибутива
* [Загрузка дистрибутива из репозитория GitHub](installation/download.md)
* [Распаковка дистрибутива, форматирование раздела и копирование на него системы](installation/unpack.md)
* [Установка системы на ПК, загрузчика и правка fstab](installation/install_sys.md)
* [Установка системы в Qemu/KVM](installation/install_qemu.md)

### Управление пакетами
* [Введение в порты](packages/intro_ports.md)
* [Введение в cpkg](packages/intro_cpkg.md)
* [Сборка бинарного пакета для cpkg](packages/makepkg.md)
