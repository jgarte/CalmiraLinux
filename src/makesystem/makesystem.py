#!/usr/bin/python3
# Скрипт для автоматизации сборки системы
# (C) 2021 Михаил Краснов <linuxoid85@gmail.com>
# Для Calmira LX4 1.1 GNU/Linux
# Версия: 0.2

## Imports ##
import os
import json
import subprocess

## Base constants ##
VERSION = "0.2"
JSON_FILE = "/etc/makesystem.json"
BuildInstructions = "/usr/src/packages/" # Файлы с инструкциями по сборке
LogDir = "/var/log/system_building/packages"
LogFile = "/var/log/system_building/system_building.log"

## Base functions ##
# Заголовок
def header_msg(message):
    print("\033[1m{}\033[0m".format(message))

# Отправка сообщений в лог
def log_msg(message):   
    f = open(LogFile, 'a')
    for index in message:
        f.write(index)

## Script body ##

# Check root
GID = os.getgid()
if GID != 0:
    print("\033[31mОШИБКА: вы должны запустить этот скрипт от имени root! \033[0m")
    exit(1)

if os.path.isdir(LogDir):
    pass
else:
    print("Создаётся директория {} ...".format(LogDir))
    os.makedirs(LogDir)

header_msg("Сборка базовой системы")
log_msg("START SYSTEM BUILDING")

with open(JSON_FILE) as f:
    fileData = json.load(f)

# Проверка на существование файлов
for File in fileData["files"]:
    PackageFile = BuildInstructions + File

    print("Testing file {}...".format(PackageFile), end = " ")
    if os.path.isfile(PackageFile):
        print("ok")
    else:
        print("\033[31mFAIL\033[0m")
    
# Сборка
for File in fileData["packages"]:
    PackageFile = BuildInstructions + File
    
    LogMessage = "Build package " + PackageFile
    log_msg(LogMessage)

    result = subprocess.run(PackageFile, shell=True)
    if result.returncode == 0:
        print("Пакет {} вернул значение 0, а значит, возможно, сборка успешна.".format(PackageFile))
    elif result.returncode == 1:
        print("Пакет {} вернул значение 1, а значит, возможно, сборка НЕПРАВИЛЬНАЯ!".format(PackageFile))
    else:
        print("Неизвестная ошибка при сборке пакета {}".format(PackageFile))