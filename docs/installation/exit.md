# Завершение установки. Выход из chroot и перезагрузка

Установка и загрузка системы завершена. Теперь вы можете выйти из `chroot` и перезагрузить компьютер.

## Выход из chroot

Для того, чтобы выйти из chroot и отмонтировать виртуальные ФС ядра, выполните:

```bash
logout

sudo umount /mnt/calmira_system/dev{/pts,}
sudo umount /mnt/calmira_system/{sys,proc,run}
```

## Размонтирование

Теперь можно отмонтировать раздел/образ жёсткого диска из системы.

### При установке в раздел

```bash
sudo umount /dev/sdX
```

Замените `sdX` на метку раздела.

### При установке на виртуальную машину

```bash
sudo umount /mnt/calmira_system
sudo qemu-nbd --disconnect /dev/nbd0
sudo rmmod nbd
```

## Перезагрузка

Введите:

```bash
sudo reboot
```

Для перезагрузки.

***

[Назад - Первичная настройка дистрибутива после копирования](setting_up.md)
