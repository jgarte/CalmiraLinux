#!/bin/bash

OK_MSG="вернул код завершения 0. Это значит, что, возможно, пакет собран успешно.\n
Это может быть ошибочно, поэтому проверьте лог сборки\e[0m\e[1m /var/log/system_building.log\e[0m"
FAIL_MSG="вернул код завершения, отличный от нуля. Это значит, что, возможно, пакет собран с ошибкой.\n
Это может быть ошибочно, поэтому проверьте лог сборки\e[0m\e[1m /var/log/system_building.log\e[0m\n"