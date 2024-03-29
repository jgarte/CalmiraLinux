# makesystem.sh

Скрипт для автоматизированной сборки системы. На данный момент применяется для сборки ночных версий Calmira, однако скоро будет использоваться и для установки небинарных (src-base) редакций Calmira.

## Файлы

- `makesystem.sh` - исходный скрипт;
- `locale.sh` - некоторые сообщения, выводимые на экран;
- `config.sh` - настройки скрипта.

## Настройка

В файле `config.sh` перечислены настройки скрипта. Среди них:

- Название дистрибутива (`DISTRO_NAME`);
- Версия дистрибутива (`DISTRO_VERSION`);
- Кодовое имя дистрибутива (`DISTRO_CODENAME`);

Эти параметры используются для разработчиков, их редактирование может сделать систему неработоспособной.

- Директория с инструкциями по сборке основных пакетов устанавливается в параметре `PACKAGES`;
- `TEST_MODE` - редим тестирования. Если установлено `enable`, то каждый пакет, для которого доступен набор тестов, будет тестироваться.

Параметры в из блока `## Message colors ##` служат для корректного отображения сообщений скрипта.

## Время сборки системы

Так как сборка любого дистрибутива занимает большое время, то даже такая небольшая система, как Calmira будет собираться долгое время.

Система собирается за 4 часа на следующей конфигурации:

- Intel Core i3-2370M
- 8 Гб ОЗУ DDR3
- 128 Гб SSD

За 7 часов на следующей конфигурации:

- Intel Celeron T3100
- 2 Гб ОЗУ DDR2
- 1 Тб HDD

Время сборки может различасться в зависимости от хост-системы, версии GCC, установленного на хост-системе, конфигурации ПК, возможных ошибок и предупреждений во время сборки (некоторые из которых можно игнорировать), а так же многих других факторов.
