<script>
	alert("Добро пожаловать!")
</script>

# Calmira GNU/Linux

Это легковесный независимый дистрибутив со своей пакетной базой.
Пакетный менеджер `cpkg`, пришедший на смену менее надёжному и простому `cpkg-tools`, находится пока в зачаточном состоянии. Название "Calmira" дано в честь одноимённой графической оболочки для Win3.11.

![Скриншот](pic/screen.png)

*Рис.1: Информация о дистрибутиве*

Главная особенность дистрибутива - его малый размер и неприхотливость. Для работы ему будет достаточно процессора Intel Atom, оперативной памяти объёмом от 30 Мб и жёсткого диска от 2-3 Гб.

Пакетный менеджер `cpkg` (релиз Calmira 2021.2), пришедший на смену `cpkg-tools` из релиза Calmira 2021.1, содержит множество изменений. Тут и более стабильная работа, и хорошая работа с зависимостями, а так же меньшая разрозненность. Установка и удаление ПО теперь следует одним и тем же правилам.

## Идеология
Дистрибутив старается следовать стандартам FHS и LSB в первую очередь. Помимо этого, дистрибутив "проповедует" KISS. В Calmira всё решает пользователь. Как ставить, куда ставить и что ставить. Как пользоваться дистрибутивом. Так же вы можете без каких-либо проблем делать сборки на основе Calmira - для этого предоставляется кросс-компилятор и временный инструментарий (https://github.com/Linuxoid85/CalmiraLinux/releases).

В ней используется необходимый минимум программного обеспечения. Вместо системы инициализации `systemd` используется классическая `sysvinit`. Не потому что продукция от RedHat нам не нравится (даже наоборот - очень нравится), но у `systemd` несколько недостатоков: более большое число зависимостей и большой вес инита.

Исходный код компонентов Calmira от её разработчиков распространяется под лицензией GNU GPLv3 и Calmira Public License.

## Установка

> Здесь приведена базовая информация. Для получения дополнительных сведений смотрите раздел [Установка](docs/installation/index.html).

Вам необходимо смонтировать раздел, на который будет скопирован дистрибутив. Раздел должен иметь файловую систему `ext4`:
```bash
sudo mkdir /mnt/calmira           # Создание точки монтирования
sudo mount /dev/sdX /mnt/calmira  # Монтирование раздела
export SYSTEM=/mnt/calmira
```

Потом распакуйте образ с системой:
```bash
sudo unsquashfs /путь/до/образа/calmira_$VERSION_$BUILD.sqsh
cp -rvxa squashfs-root/* $SYSTEM
```

* `$VERSION` - версия дистрибутива
* `$BUILD` - версия билда дистрибутива

Например, `calmira_2021.2_build2.sqsh`.

После чего установите загрузчик GRUB и приступите к настройке дистрибутива

> Вам может понадобиться пересобрать ядро, так как в нём нет некоторых драйверов, которые могут понадобиться пользователям. Например, поддержка сети.

Перед тем, как устанавливать GRUB на ПК с UEFI, то установите из все порты из `base/grub-efi` в следующем порядке:
* `efivar`;
* `popt` (находится не в `base/grub-efi`, а в `general_libs`);
* `efibootmgr`;
* `grub`

Для этого выполнить:

```bash
cd /usr/ports/$КАТЕГОРИЯ/$ПАКЕТ
./install
```

`$КАТЕГОРИЯ` - категория, в котором располагается порт. Например, `base/grub-efi` или `general_libs`

`$ПАКЕТ` - имя нужного пакета. Например, `efibootmgr`.

## Документация

Раздел с документацией к дистрибутиву доступен [здесь](docs/index.html). В нём описан процесс установки дистрибутива из sqsh, подготовка LiveCD/LiveUSB и последующая установка с них, либо же подготовка образа жёсткого диска для Qemu/KVM (`qcow2`). Так же описан процесс сборки ПО из исходного кода и пересборка ядра системы.

## Релизы

| Релиз  | Кодовое имя | Изменения | Дата выхода |
|:-------|:-----------:|:----------|:-----------:|
| 2021.1 | Orion       | Initial Release       | 28.05.2021  |
| 2021.2 | Andromeda   | замена `cpkg-tools` на `cpkg`, пересборка `gmp`, добавление новых функций | 28.05.2021 |
| 2021.3 | Andromeda   | добавление в пакетный менеджер `cpkg` новых фукций, таких как сборка пакета из исходников, очистка кеша, скачивание пакета из исходных текстов; повышение стабильности как пакетного менеджера, так и дистрибутива в целом | 15.06.2021 |
| LX4 1.0 | Cassiopeia (RC), Orion (Stable Release)  | переход на LX4 версии 1.1-1.2, добавление опциональных бинарных пакетов, повышение стабильности, удаление пакетного менеджера `cpkg` | 05.07.2021 |
| LX4 1.1 | Aquarius    | добавление системы портов, обновление до LX4 1.3, возвращение `cpkg` в поставку дистрибутива | Запланировано на 15.11.2021 |

[Road Map](docs/roadmap.md)

## Системные требования

### Минимальные

| Пункт | Значение |
|:------|:---------|
| ОЗУ   | 55 Мб    |
| ЦП    | Uknown Intel x86_64 >= 800 ГГц |
| Место на жёстком диске | 1.5 Гб |

### Рекомендуемые

| Пункт | Значение |
|:------|:---------|
| ОЗУ   | 80-100 Мб    |
| ЦП    | Uknown Intel x86_64 >= 1 ГГц |
| Место на жёстком диске | 1.5 Гб |

Как вы могли заметить, Calmir'е важен объём оперативной памяти. Хотя работать она может и с куда меньшими:

![Потребление](pic/calm_ram.png)

*Рис.2: тестовая версия Calmira LX4 1.1 запущена в qemu.*

На скриншоте выше хорошо видно, что система потребляет 13 Мб оперативной памяти, что на 2021 год - очень ничтожно. А ведь это полностью рабочая система, умеющая редактирвоать файлы, работать с архивами, скачивать файлы из интернета, работать с репозиториями git и многое другое!

> **Пометка**. Данные приблизительные. В зависимости от железа ПК они могут разниться. Так, например, на ноутбуке Samsung NP300E5C с 8 Гб ОЗУ система потребляет уже 36 Мб ОЗУ.

Однако не стоит считать, что эта система заработает на **очень** старом железе. Во-первых, при сборке некоторого ПО может возникать ошибка вроде `Illegal Instruction`, прерывающая процесс сборки. Это может возникать на старых ЦП Intel/AMD до 2005 года. Так же эта система собирается только для архитектуры x86_64/ Работать будет на процессоре 64 бит, на 32-ух битном ЦП попросту не заработает.

## Скачивание дистрибутива

На данный момент не собираются загрузочные iso-образы с дистрибутивом. Он распространяется в виде squashfs-снимков для распаковки и работы из-под другого GNU/Linux-дистрибутива (посредством `chroot`), установки в виртуальную машину (например, в qemu), либо же копирования содержимого снимка на флешку или раздел жёсткого диска для полноценного использования на реальном железе.

* Последняя (на данный момент) версия Calmira LX4 1.0 доступна [здесь](https://github.com/Linuxoid85/CalmiraLinux/releases/download/v1.0/calmira-1.0.sqsh) (207 Мб squashfs-образ).

> Долгожданная версия LX4 1.1 выйдет 15.11.2021 с большим числом изменений и нововведений.

* Временный инструментарий для восстановления/пересборки доступен [здесь](https://github.com/Linuxoid85/CalmiraLinux/releases/download/v1.1temp/calm-temp-sys_lx4.1.1.tar.xz) (143 Мб tar архив, сжатый методом `xz`).

* Все релизы доступны [здесь](https://github.com/Linuxoid85/CalmiraLinux/releases).

## TODO

* Создание загрузочного iso/img образа системы.

## Контакты
* E-mail разработчика: <linuxoid85@gmail.com>
* Разработчик ВКонтакте: [@linuxoid85](https://vk.com/linuxoid85)

**НАМ ТРЕБУЮТСЯ ДИЗАЙНЕРЫ!** О подробностях писать пользователю @linuxoid85.
