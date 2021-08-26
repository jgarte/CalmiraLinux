#!/bin/bash
# Скрипт для автоматизированной сборки Calmira GNU/Linux
# (C) 2021 Михаил Краснов <linuxoid85@gmail.com>
# Для Calmira LX4 1.1 GNU/Linux
# Версия: 0.1

VERSION="0.1"

## Settings ##
DISTRO_NAME="Calmira LX4"
DISTRO_VERSION="1.1 RC2 dev"

## User settings ##
source config.sh

## Functions ##
source locale.sh

# Заголовок
function header_msg() {
	echo -e "\n${COL_HEADER}$1${COL_NORMAL}"
}

# Отправка сообщений в лог
function log_msg() {
	echo -e "$(date) $1" >> /var/log/system_building/system_building.log
}

## Script ##

# Check root
if [ $(whoami) != "root" ]; then
	echo "Ошибка: вы должны запустить скрипт $0 от имени root!"
	exit 1
fi

# Check log dir

if [ -d "/var/log/system_building" ]; then
	echo "log directory: ok"
else
	mkdir -v /var/log/system_building
fi

# Cmd args parsing
while [ -n "$1" ]; do
	case "$1" in
		# Режим тестирования пакетов - если он
		# включен, то каждый пакет будет проходить
		# тестирование (make check/test),
		# результаты которого будут перенаправляться
		# в файл лога
		--enable-test)
			echo "Включен режим тестирования пакетов"
			export TEST_MODE="enable"
		;;
		
		# Режим multilib - если он включен, то
		# будет собрана multilib-редакция системы
		--enable-multilib)
			echo "Сборка Multilib-системы включена"
			export PACKAGES="multilib-packages"
		;;
		
		# Ответить yes (Y/y) на все запросы утилиты
		-y)
			echo "Теперь скрипт будет отвечать утвердительно на все вопросы"
			export RUN = "y"
		;;
		
		# Версия скрипта
		-v|--version)
			echo "$VERSION"
			exit 0
		;;
	esac
	shift
done

# Сборка и установка пакетов
header_msg "Сборка базовой системы"
log_msg "START SYSTEM BUILDING"

for SCRIPT in "bash-files" "iana-etc" "glibc" "zlib-ng" "bzip2"           \
			"xz" "zstd" "file" "readline" "m4" "bc" "flex" "binutils"     \
			"gmp" "mpfr" "mpc" "attr" "acl" "libcap" "shadow" "gcc"       \
			"pkg-config" "ncurses" "sed" "psmisc" "gettext" "bison"       \
			"grep" "bash" "libtool" "gdbm" "gperf" "expat" "inetutils"    \
			"perl" "xml-parser" "intltool" "autoconf" "automake" "kmod"   \
			"libelf" "libffi" "openssl" "python" "ninja" "meson"          \
			"coreutils" "check" "diffutils" "gawk" "findutils" "groff"    \
			"less" "gzip" "iproute2" "kbd" "libpipeline" "make" "patch"   \
			"tar" "man-db" "texinfo" "popt" "freetype" "wget" "libtasn1"  \
			"p11-kit" "make-ca" "vim" "eudev" "procps" "util-linux"       \
			"sysklogd" "sysvinit" "bootscripts" "e2fsprogs" "grub"        \
			"curl" "git" "pciutils" "which" "linux"; do
	echo -e "\a${COL_MESSAGE}Установка пакета ${COL_NORMAL}${COL_HEADER}$SCRIPT${COL_NORMAL}${COL_MESSAGE}...${COL_NORMAL}"

	if [ -f "$PACKAGES/$SCRIPT" ]; then
		chmod +x $PACKAGES/$SCRIPT
		log_msg "found package $SCRIPT"
		if $PACKAGES/$SCRIPT  2>&1 |tee -a /var/log/system-building/$SCRIPT-build.log; then
			echo "Code: $?"
			
			echo -e "\a${COL_HEADER}$SCRIPT${COL_NORMAL}${COL_MESSAGE} $OK_MSG"
			log_msg "$SCRIPT: building OK"
		else
			echo "Code: $?"
			
			log_msg "$SCRIPT: building FAIL! ! !"
			
			echo -e "\a\a${COL_HEADER}$SCRIPT${COL_NORMAL}${COL_ERROR} $FAIL_MSG"
			echo -n "Завершить сборку (y/n)? "
			read run
			
			if [ $run = "Y" ] || [ $run = "y" ]; then
				echo "Выход с кодом завершения 1"
				exit 1
			elif [ $run = "N" ] || [ $run = "n" ]; then
				echo -e "${COL_ERROR}Продолжается сборка. Работа конечной системы и корректность дальнейшей работы не гарантируется.${COL_NORMAL}"
			else
				echo "Неправильный ввод. Выход из программы."
				exit 1
			fi
		fi
	else
		log_msg "$SCRIPT: FAIL: doesn't exists"
		echo -e "\a\a${COL_ERROR}ОШИБКА: пакета '$SCRIPT' не существует!${COL_NORMAL}"
		echo -n "Прервать сборку (Y/n) "
		read run

		if [ $run = "Y" ] || [ $run = "y" ]; then
			echo "Прервано."
			exit 1
		elif [ $run = "N" ] || [ $run = "n" ]; then
			echo -e "${COL_ERROR}Продолжается сборка. Работа конечной системы и корректность дальнейшей сборки не гарантируется.${COL_NORMAL}"
		else
			echo "Неправильный ввод. Выход из программы."
			exit 1
		fi
	fi
done

unset TEST_MODE

log_msg "END SYSTEM BUILDING\n\n"
header_msg "Система собрана. Если есть ошибки, исправьте их."

## Настройка системы ##
echo "Продолжить настройку? (Y/n) "
read run
if [ $run = "Y" ] || [ $run = "y" ] || [ $RUN = "y" ]; then
	echo "Продолжение"
	log_msg "START SETTING UP BASE SYSTEM"
elif [ $run = "N" ] || [ $run = "n" ]; then
	log_msg "Exit."
	echo "Выход."
	exit 0
else
	echo "Неправильный ввод. Выход из программы."
	exit 1
fi

header_msg "Установка пароля root"
log_msg "setting up root password"

echo -e "\e[1;31mEnter the root password:\e[0m"
passwd root

header_msg "Настройка fstab"
log_msg "setting up fstab file"

echo -e "\nВведите метку корневого раздела, на который установлена система ${COL_HEADER}(sda1, hdb3, etc.)${COL_NORMAL}: "
read DISK # <<-- DOESN'T UNSET THIS VARIABLE!

echo "# Begin /etc/fstab
# Written for Calmira LX4 1.1
# (C) 2021 Michail Krasnov <linuxoid85@gmail.com>

# file system  mount-point  type     options             dump  fsck
#                                                              order

/dev/$DISK     /            ext4     defaults             1     1 
proc           /proc        proc     nosuid,noexec,nodev  0     0
sysfs          /sys         sysfs    nosuid,noexec,nodev  0     0
devpts         /dev/pts     devpts   gid=5,mode=620       0     0
tmpfs          /run         tmpfs    defaults             0     0
devtmpfs       /dev         devtmpfs mode=0755,nosuid     0     0
" > /etc/fstab

header_msg "Создание '/etc/shells'"
log_msg "setting up shells file"

cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

header_msg "Настройка SysVInit"

echo "настройка inittab..."
log_msg "setting up inittab file"
cat > /etc/inittab << "EOF"
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S016:once:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600

# End /etc/inittab
EOF

echo "настройка часов..."
log_msg "setting up sysconfig/clock file"
cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
EOF

echo "настройка консоли..."
log_msg "setting up sysconfig/console file"
cat > /etc/sysconfig/console << "EOF"
# Begin /etc/sysconfig/console

UNICODE="1"
KEYMAP="ruwin_alt_sh-UTF-8"
FONT="cyr-sun16"

# End /etc/sysconfig/console
EOF

log_msg "install grub bootloader"
read -p "Введите диск, на который собираетесь устанавливать загрузчик (пока поддерживается только MBR/Legacy BIOS) (sda, sdb, hdc, et cetera): " SYSDISK
read -p "Введите номер нужного диска (1, 2, 3, 5, etc.): " DISKNUMBER
read -p "Введите номер нужного раздела (1, 2, 3, 5, etc.): " PARTNUMBER

grub-install /dev/$SYSDISK

echo "# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd$DISKNUMBER,$PARTNUMBER)

menuentry \"$GRUB_NAME_DISTRO\" {
        linux /boot/vmlinuz root=/dev/$DISK ro
}" > /boot/grub/grub.cfg

echo "запись информации о системе"
log_msg "setting up system info files"
echo "NAME=\"$DISTRO_NAME\"
VERSION=\"$DISTRO_VERSION\"
ID=calmiralinux
PRETTY_NAME=\"$DISTRO_NAME $DISTRO_VERSION\"
VERSION_CODENAME=\"$DISTRO_CODENAME\"" > /etc/os-release

echo "DISTRIB_ID=\"$DISTRO_NAME\"
DISTRIB_RELEASE=\"$DISTRO_VERSION\"
DISTRIB_CODENAME=\"$DISTRO_CODENAME\"
DISTRIB_DESCRIPTION=\"$DISTRO_NAME $DISTRO_DESCRIPTION\"" > /etc/lsb-release

log_msg "setting up computer hostname"
echo "Введите имя хоста (по умолчанию: calm-pc): "
read HOSTNAME

if [ $HOSTNAME = '' ] || [ -z $HOSTNAME ]; then
	echo "calm-pc" > /etc/hostname
else
	echo "$HOSTNAME" > /etc/hostname
fi

log_msg "END SYSTEM SETTING UP"
echo "Настройка завершена!"

exit 0
