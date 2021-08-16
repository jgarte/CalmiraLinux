#!/bin/bash
# Скрипт для автоматической сборки Calmira GNU/Linux
# (C) 2021 Михаил Краснов <linuxoid85@gmail.com>
# Для Calmira LX4 1.1 GNU/Linux

# Check root
if [ $(whoami) != "root" ]; then
	echo "Ошибка: вы должны запустить скрипт $0 от имени root!"
	exit 1
fi

# Список пакетов
PACKAGES="bash-files iana-etc glibc zlib-ng bzip2 xz zstd file readline m4 bc flex binutils gmp mpfr mpc attr acl libcap shadow gcc pkg-config ncurses sed psmisc gettext bison grep bash libtool gdbm gperf expat inetutils perl xml-parser intltool autoconf automake kmod libelf libffi openssl python ninja meson coreutils check diffutils gawk findutils groff less gzip iproute2 kbd libpipeline make patch tar man-db texinfo popt freetype wget libtasn1 p11-kit make-ca vim eudev procps util-linux sysklogd sysvinit bootscripts e2fsprogs grub linux"

# Сборка и установка пакета
for SCRIPT in $PACKAGES; do
	echo "$SCRIPT" >> .auto_log
	echo -e "\e[1;35mУстановка пакета \e[0m\e[1m$SCRIPT\e[0m\e[1;35m...\e[0m"

	if [ -f "packages/$SCRIPT" ]; then
		chmod +x packages/$SCRIPT
		./packages/$SCRIPT
	else
		echo -e "\e[1;31mОШИБКА: пакета '$SCRIPT' не существует!\e[0m"
		echo -n "Прервать сборку (Y/n) "
		read run

		if [ $run = "Y" ] || [ $run = "y" ]; then
			echo "Прервано."
			exit 1
		elif [ $run = "N" ] || [ $run = "n" ]; then
			echo -e "\e[1;31mПродолжается сборка. Работа конечной системы и корректность дальнейшей сборки не гарантируется.\e[0m"
		else
			echo "Неправильный ввод. Выход из программы."
			exit 1
		fi
done

echo -e "\e[1;32mСистема собрана. Если есть ошибки, исправьте их.\e[0m"
exit 0