# ver

Скрипт для отображения базовой информации о системе. Читает файл `/etc/calm-release`.

## Структура `/etc/calm-release`

```json
{
    "distroName": "имя дистрибутива",
    "distroVersion": "версия дистрибутива",
    "distroCodename": "кодовое имя дистрибутива",
    "distroBuild": "номер сборки дистрибутива",
    "distroBuildDate": "дата сборки дистрибутива",
    "distroDesc": "описание дистрибутива",
    "distroArch": "архитектура дистрибутива"
}
```

## Работа со скриптом

```bash
$ ver
```

> Опций и ключей у скрипта нет.

Примерный вывод:

```
$ ver

        System name: Calmira LX4
        System version: 1.1
        System codename: Aquarius
        System build: 5

(C) 2021 Michail Krasnov <linuxoid85@gmail.com> for Calmira LX4 1.1

```