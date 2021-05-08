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

#############################
### Инициализация скрипта ###
#############################
while [ -n "$1" ]; do
	case "$1" in
		--quiet)
			echo "Включен тихий режим скрипта"
			QUIET="true"
		;;
		
		--unpack-only)
			echo "Пакет только распакуется в кеш"
			UNPACK="true"
		;;
		
		--)
			shift
			break
		;;
		*)
			echo "$1 - не опция пакетного менеджера cpkgi"
		;;
	esac
	shift
done

count=1
for param in $@; do
	echo "Выбранные пакеты: #$count: $param"
	count=$(( $count + 1 ))
done


# Функция для поиска пакета в файловой системе
searchPKG() {
	if [ -n $1 ]; then
		echo -n
	else
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

# Распаковка пакета
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

# Тестирование пакета на соответствие платформе Calmira
TestPlatform() {
	echo -n "Установка соответствия платформе CPL 1... "
	if [ $CPL_PLATFORM = $CPL ]; then
		echo "Соответствует"
	else
		echo "Не соответствует!"
		echo -e "\nСоответствие платформе CPL не установлено. Это
значит, что пакет или битый, или конфигурационный файл конфига
не содержит переменную 'CPL_PLATFORM', в таком случае обратитесь
к мейнтейнеру пакета.
Мейнтейнер: $MAINTAINER

В том случае, если переменная 'CPL_PLATFORM' в конфигурационном файле пакета
установлена и имеет \e[1mправильное значение\e[0m, то обновите систему Calmira
GNU/Linux до новой версии.

Версия платформы Calmira: $CPL
Минимальная версия платформы, на которой пакет работает: $CPL_PLATFORM"
		echo -e "\n Вы действительно желаете установить этот пакет?
Это действие небезопасно и может сломать вашу систему!
"
		echo -n "Ввод (y/N): " && read run
		
		if [ $run = "y" ]; then
			echo "Выбрано продолжение установки. ВНИМАНИЕ! Это небезопасно."
		else
			echo "Продолжение установки не выбрано. Выход из программы cpkgi."
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
		echo "Директория с пакетом найдена!"
	else
		echo -e "\e[1;31mОШИБКА:\e[0m директория с данными пакета не найдена.
Работа cpkgi невозможна. Аварийный выход."
		exit 0
	fi

	cd pkg
	echo "Копирование данных..."
	cp -r * /

	echo "Внесение пакета в базу данных cpkg-tools..."
	createDB
	
	echo "Запуск послеустановочных скриптов..."
	PostINST	# Запуск post-install скриптов

	echo "Готово!"
	exit 0
}

installPKG $1
