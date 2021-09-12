#!/usr/bin/python3
# Скрипт для автоматизации сборки системы
# (C) 2021 Михаил Краснов <linuxoid85@gmail.com>
# Для Calmira LX4 1.1 GNU/Linux
# Версия: 0.2

## TODOS ##
# TODO - Add build time analysis and redirect messages to the log for all build scripts

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

# Диалог с пользователем
def dialog_msg():
    print("Прожолжить?")

    run = input()
    if run == "y" or run == "Y":
        print("Продолжается сборка...")
    elif run == "n" or run == "N":
        print("Сборка прервана!")
        exit(1)
    else:
        print("НЕПРАВИЛЬНОЕ ЗНАЧЕНИЕ ({}). Аварийное завершение работы.".format(run))


## Script body ##

# Check root
GID = os.getgid()
if GID != 0:
    print("\033[31mОШИБКА: вы должны запустить этот скрипт от имени root! \033[0m")
    exit(1)

if os.path.isdir(LogDir):
    pass
else:
    print("Создаётся директория {}...".format(LogDir))
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
        print("\033[32mok\033[0m")
    else:
        print("\033[31mFAIL\033[0m")
        ErrorPackage = True

if ErrorPackage:
    print("Выявлены ошибки при проверке на наличие нужных файлов!") 
    dialog_msg
    
"""
Building a system.

The required script with assembly instructions is launched.

If it returned 0, then the build was successful. If it returned a value
other than zero, then a warning about incorrect building is displayed.
"""
for File in fileData["packages"]:
    PackageFile = BuildInstructions + File
    
    LogMessage = "Build package " + File
    log_msg(LogMessage)

    result = subprocess.run(PackageFile, shell=True)
    if result.returncode == 0:
        print("Package {} returned 0, which means the build is probably successful.".format(PackageFile))
    elif result.returncode == 1:
        print("Package {} returned a value of 1, which means the assembly is probably WRONG!".format(PackageFile))
        dialog_msg
    else:
        print("Unknown error while building package {}".format(PackageFile))
        dialog_msg