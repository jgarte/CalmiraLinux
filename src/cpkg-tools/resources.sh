#!/bin/bash
#
# resources.sh
#
# Общие переменные и функции для работы с пакетным менеджером cpkg-tools
# (C) Linuxoid85, 2021
#
# Для дистрибутива Calmira GNU/Linux
# Данное ПО распространяется под лицензией GNU GPLv3 и предоставляется БЕЗ
# каких-либо гарантий. 

DATABASE=/var/cache/cpkg-tools/database


# Простая функция. Предназначена для ведения
# логов. Синтаксис:
# logMSG [ДЕЙСТВИЕ] [РЕЗУЛЬТАТ]
# РЕЗУЛЬТАТ может быть: OK, warning, error
logMSG() {
	MESSAGE="[ $1 ] [ $2 ] [ `date` ]"
	echo "$MESSAGE" >> $LOG
}

# Тестирование на наличие директории
testDIR() {
	case $1 in
		# Проверка на наличие базы данных пакетов
		db)
			if test -f "$DATABASE"; then
				RET=1
				echo "Database is found"
			else
				RET=0
				echo "Database DOESN'T found!!!"
			fi

			# Если поставлена опция "ex", то осуществится выход из программы,
			# если база данных пакета не найдена
			if [ $2 = "ex" ]; then
				if [ $RET = 0 ]; then
					echo "Exit cpkg-tools."
					exit 0
				fi
			else
				# Создание базы данных
				touch $DATABASE
			fi
		;;

		# Проверка на наличие кеша
		cache)
			if test -d "/var/cache/cpkg-tools"; then
				RET=1
				echo "Cache is found"
			else
				RET=0
				echo "Cache DOESN'T found!!!"
				mkdir /var/cache/cpkg-tools
			fi
		;;
	esac
}

# Создание базы данных пакетов
# В базе данных хранится название пакета, его
# описание, содержимое пакета
# База данных представляет собой BASH-скрипт,
# описания которых являются его функциями. ПРИМЕР:
# neofetch() {
# 	NAME="neofetch"
# 	DESCRIPTION="info about system"
# 	FILES="/usr/bin/neofetch /usr/share/neofetch/config.conf"
# WARNING - файлы разделяются между собой ПРОБЕЛОМ
createDB() {
 	testDIR db ex	# Проверка на наличие базы данных
	echo "`cat ../config.sh`" >> $DATABASE
}
