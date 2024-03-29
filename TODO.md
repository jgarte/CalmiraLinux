# TODO

## Релиз LX4 1.2
- [ ] Добавление утилиты для быстрого включения/выключения сервисов SysVInit;
- [ ] Добавление утилиты для просмотра состояния АКБ ноутбука (статус - заряжается/разражается; процент заряда);
- [ ] Введение в минимальную поставку дистрибутива пакетов `sqlite3` и `port-utils`;
- [ ] Добавить системную документацию в минимальную поставку дистрибутива;
- [ ] Неизвестная причина сообщения `snd_hda_intel 0000:01:00.1: Cannot probe codecs, giving up`;
- [ ] Пофиксить кривой сервис `dhcpcd` (проблема в том, что программа находится в `/usr/sbin/dhcpcd`, а сервис ищет в `/sbin/dhcpcd`);
- [ ] Добавить `LOGLEVEL=1` в `/etc/sysconfig/console`;
- [ ] Добавить пакет `ver` в минимальную поставку дистрибутива;
- [ ] Добавить в ядро поддержку новых моделей сетевых и звуковых карт;
- [ ] Добавить новые скрипты для настройки системы в средство сборки системы `makesystem`;
- [ ] Задействовать скрипт для сборки системы из исходного кода в новой src-редакции дистрибутива.

## Релиз LX4 1.1
* Доработать скрипт для автоматизации сборки системы для использования системы портов по умолчанию;
* Добавление сборки дополнительных пакетов при помощи `makesystem.sh`;
* Добавить в раздел администрирования информацию о работе в сетях;
* Добавить в раздел администрирования инструкцию об управлении процессами;
* Добавить в документацию раздел об администрировании Calmira;
* Реализовать нормальную поддержку сети для некоторых сетевых карт;
* Переписать `/etc/issue`;
* Обеспечение поддержки EFI;
* Добавление системы портов;
* Добавление своих конфигов;
* Возвращение cpkg в официальную поставку;
* Повышение стабильности дистрибутива;
* **Обновления пакетов:**
  * `iproute2-5.13`;
  * `linux-5.13.1`;
  * `texinfo-6.8`;
  * `less-590`;
  * `cpkg-1.0`;
* Возвращение раздельной иерархии каталогов, так как такая иерархия является намного надёжнее новой упрощённой;
* Опциональная возможность загрузки `/proc`, `/run` и `/sys` в оперативную память (посредством `tmpfs`), либо же обычный вариант. В первом случае (загрузка содержимого каталогов в ОЗУ) система работает несколько быстрее, но потребляет больше; во втором случае система работает несколько медленнее, но меньше занимает в оперативной памяти.
* Удаление пакета `popt` из минимальной поставки, так как он нужен только при обеспечении загрузки системы на UEFI. Обеспечение является опциональной возможностью, поэтому и пакет должен быть опциональным и не предоставляться по умолчанию;
* Возвращение bash-скрипта вместо программы `which`, однако предоставление последней в портах.

## Релиз LX4 1.0
* Прекращение использования LFS в качестве базы и переход на LX4;
* Повышение стабильности дистрибутива;
* Обеспечение поддержки EFI из коробки;

## Релиз 2021.3 (разработка прекратилась во время тестирования)
* Добавление в пакетный менеджер `cpkg` новых функций, повышение стабильности;
* Добавление в минимальную поставку дополнительных пакетов;
* Добавление всех пакетов базовой системы в репозитории ПО;
* Формирование точного графика выхода релизов дистрибутива;

## Релиз 2021.2
* Исправление багов и добавление новых функций в пакетном менеджере `cpkg-tools`;
* Пересборка GMP с отвязкой оптимизации к процессору;

## Релиз 2021.1
* Initial Release
