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

# Вывод сообщений на экран
printMessage() {
# $1 - ключи echo
# $2 - текстовое сообщение
	if [ $QUIET = "true" ]; then
		echo "$1" "$2" > /dev/null
	else
		echo "$1" "$2"
	fi
}

# Диалог
printDialog() {
	if [ $QUIET = "true" ]; then
		echo "$1" > /dev/null
		run="Y"
	else
		echo "$1 (Y/n): " && read run
	fi
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

# Отобразить справку
printHelp() {
	intro="Справка по пакетному менеджеру cpkg-tools"
	case $1 in
		cpkgi)
			echo "$intro

 сpkgi - модуль пакетного менеджера cpkgi-tools, отвечает за установку пакетов и
ведение базы данных пакетов.

 ПОДДЕРЖИВАЕМЫЕ КЛЮЧИ:
  * --quiet - так называемый 'тихий' режим, когда на экран выводится минимум
сообщений, а на все вопросы скрипт сам отвечает утвердительно.
  * --unpack-only - с этим ключом скрипт только распакует пакет в директорию
/var/cache/cpkg-tools с кешем.
  * --clean-cache - ключ для очистки кеша cpkg-tools, в который распаковываются
 пакеты. РЕКОМЕНДУЕТСЯ использовать вместе с установкой пакета

 СИНТАКСИС:
  cpkgi [--quiet --unpack-only --clean-db] -- PKG.cpkgi

 [ ... ] - необходимые пользователю ключи
 -- - эта конструкция означает, что блок ключей закончен и начат блок объявления
пакета
 PKG.cpkgi - название пакета"
 		;;
 		
 		*)
 			logMSG "Ошибка: функция printHelp возвратила ошибочный результат: неправильно упомянут раздел справки" "ERROR"
 		;;
 	esac
}

# Тестирование на наличие прав
testUser() {
	if [[ `whoami` -ne "root" ]]; then
		printMessage "Ошибка! У вас недостаточно прав для запуска программы"
		exit 0
	fi
}
