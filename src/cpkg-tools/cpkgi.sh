#!/bin/bash
#
# cpkgi
# Установка пакета
# (C) Linuxoid85, 2021
#
# Для дистрибутива Calmira GNU/Linux
# Данное ПО распространяется под лицензией GNU GPLv3 и предоставляется БЕЗ
# каких-либо гарантий.

source resources.sh

# Функция для поиска пакета в файловой системе
searchPKG() {
	if [ $1 = "" ]; then
		echo "ОШИБКА: вы не ввели имя пакета. Выход из программы установки пакетов."
		exit 0
	fi

	# Поиск пакета по шаблону $PKG.cpkg
	echo -n "Поиск пакета по шаблону PKG.cpkg... "
	if test -f "$1"; then
		echo -e "\e[1;32mУСПЕШНО\e[0m"
	else
		RESULT_SEARCH=0
		echo -e "\e[1;31mНЕ НАЙДЕНО\e[0m"
		exit 0
	fi
}

unpackPKG() {
	testDIR cache
	
	cp $1 /var/cache/cpkg-tools
	cd /var/cache/cpkg-tools
	tar -xf $1
	if test -d PKG; then
		echo -e "\e[1;32mГотово\e[0m"
	else
		echo -e "\e[1;31mОШИБКА\e[0m"
	fi
}

installPKG() {
	searchPKG $1	# Поиск пакета
	unpackPKG $1	# Распаковка пакета

	cd PKG
	if test -f "config.sh"; then
		source config.sh
	else
		echo -e "\e[1;31mОШИБКА:\e[0m конфигурационный файл `pwd`/config.sh не найден.
Работа cpkgi невозможна. Аварийный выход."
		exit 0
	fi

	if test -d "pkg"; then
		echo "Директория с пакетом найдена!"
	else
		echo -e "\e[1;31mОШИБКА:\e[0m директория с данными пакета не найдена.
Работа cpkgi невозможна. Аварийный выход."
	fi

	cd pkg
	echo "Копирование данных..."
	cp -r * /

	echo "Внесение пакета в базу данных cpkg-tools..."
	createDB

	echo "Готово!"
	exit 0
}

installPKG $1