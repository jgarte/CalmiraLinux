#!/bin/bash
#
# cpkgi
# Установка пакета
# (C) Linuxoid85, 2021
#
# Для дистрибутива Calmira GNU/Linux
# Данное ПО распространяется под лицензией GNU GPLv3 и предоставляется БЕЗ
# каких-либо гарантий.
#
# Build 2021.1 Alpha 1
#

source resources.sh	# Общие функции, переменные и настройки

#############################
### Инициализация скрипта ###
#############################
QUIET="0"	# Дефолтное значение переменной
UNPACK="0"	# Дефолтное значение переменной

testUser	# Тестирование на наличие прав для запуска этого скрипта

while [ -n "$1" ]; do
	case "$1" in
		--quiet)
			echo "Включен тихий режим скрипта"
			QUIET="true"
		;;
		
		--unpack-only)
			printMessage "Пакет только распакуется в кеш"
			UNPACK="true"
		;;
		
		--clean-cache)
			printMessage "Очистка кеша пакетов"
			printDialog "Действительно очистить кеш пакетов?"
			
			if [ $run = "Y" ]; then
				rm -rf /var/cache/cpkg-tools/*
			else
				printMessage "Очистка кеша не выбрана"
			fi
		;;
		
		--info)
			param="$2"
			echo -e "\nИнформация о пакете $param:"
			echo "СТАТ   ИМЯ   ВЕРСИЯ"
			grep "$param" $PKGLIST
			
			exit 0
		;;
		
		--info-dep)
			if [ -n $2 ]; then
				param="$2"
				grep "DEP $2" $PKGLIST
			else
				echo -e "Список пакетов, установленных как зависимости: \n"
				grep "DEP" $PKGLIST
			fi
			
			exit 0
		;;
		
		--help)
			printHelp cpkgi
		;;			
		
		--)
			shift
			break
		;;
		
		*)
			printHelp cpkgi
		;;
	esac
	shift
done

count=1
for param in $@; do
	echo "Выбранный пакет: #$count: $param"
	count=$(( $count + 1 ))
done


#####################################
### Основные функции и переменные ###
#####################################

# Функция для поиска пакета в файловой системе
searchPKG() {
	if [ -n $1 ]; then
		printNullMsg
	else
		echo "ОШИБКА: вы не ввели имя пакета. Выход из программы установки пакетов."
		exit 0
	fi

	# Поиск пакета по шаблону $PKG.cpkg
	printMessage -n "Поиск пакета по шаблону PKG.cpkg... "
	if test -f "$1"; then
		printMessage -e "\e[1;32mУСПЕШНО\e[0m"
	else
		RESULT_SEARCH=0
		printMessage -e "\e[1;31mНЕ НАЙДЕНО\e[0m"
		exit 0
	fi
}

# Распаковка пакета
unpackPKG() {
	testDIR cache
	
	cp $1 /var/cache/cpkg-tools
	cd /var/cache/cpkg-tools
	
	if [ $QUIET = "true" ]; then
		tar -xf $1
	else
		tar -xvf $1
	fi
	
	if test -d PKG; then
		printMessage -e "\e[1;32mГотово\e[0m"
	else
		printMessage -e "\e[1;31mОШИБКА\e[0m"
		exit 0
	fi
	
	if [ $UNPACK = "true" ]; then
		echo "Выбрана только распаковка (ключ '--unpack-only')"
		exit 0
	fi
}

# Тестирование пакета на соответствие платформе Calmira
TestPlatform() {
	printMessage -n "Установка соответствия платформе CPL 1... "
	if [ $CPL_PLATFORM = $CPL ]; then
		printMessage "Соответствует"
	else
		printMessage "Не соответствует!"
		printMessage -e "\nСоответствие платформе CPL не установлено. Это
значит, что пакет или битый, или конфигурационный файл конфига
не содержит переменную 'CPL_PLATFORM', в таком случае обратитесь
к мейнтейнеру пакета.
Мейнтейнер: $MAINTAINER

В том случае, если переменная 'CPL_PLATFORM' в конфигурационном файле пакета
установлена и имеет \e[1mправильное значение\e[0m, то обновите систему Calmira
GNU/Linux до новой версии.

Версия платформы Calmira: $CPL
Минимальная версия платформы, на которой пакет работает: $CPL_PLATFORM"
		printMessage -e "\n Вы действительно желаете установить этот пакет?
Это действие небезопасно и может сломать вашу систему!
"
		printDialog "Ввод"
		
		if [ $run = "y" ]; then
			printMessage "Выбрано продолжение установки. ВНИМАНИЕ! Это небезопасно."
		else
			printMessage "Продолжение установки не выбрано. Выход из программы cpkgi."
			exit 0
		fi
	fi
}

# Функция для запуска pre-install скриптов. Эти скрипты
# запускаются перед началом установки пакета и нужны
# для базовой настройки системы или окружения
PreINST() {
	if test -f "preinstall.sh"; then
		chmod +x preinstall.sh
		bash preinstall.sh
	else
		echo "Pre-install скрипты не найдены"
	fi
}

# Функция для запуска post-install скриптов. Эти
# скрипты запускаются после установки пакета и
# нужны для базовой настройки установленной программы
# или окружения
PostINST() {
	if test -f "../postinstall.sh"; then
		chmod +x ../postinstall.sh
		bash ../postinstall.sh
	else
		echo "Post-install скрипты не найдены"
	fi
}


# Процедура для установки пакета, цепляющая за собой
# большинство предыдущих функций
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
	
	TestPlatform	# Тестирование пакета на совместимость платформе
	PreINST		# Запуск pre-install скриптов

	if test -d "pkg"; then
		printMessage "Директория с пакетом найдена!"
	else
		echo -e "\e[1;31mОШИБКА:\e[0m директория с данными пакета не найдена.
Работа cpkgi невозможна. Аварийный выход."
		exit 0
	fi

	cd pkg
	printMessage "Копирование данных..."
	cp -r * /

	printMessage "Внесение пакета в базу данных cpkg-tools..."
	createDB
	writePkgList
	
	printMessage "Запуск послеустановочных скриптов..."
	PostINST	# Запуск post-install скриптов

	echo "Готово!"
	exit 0
}

installPKG $1
