# Настройка часов

При загрузке считывается информация из аппаратных часов - CMOS. Программно нельзя определить, какой часовой пояс используют часы CMOS, однако вы можете выполнить команду `hwclock --localtime --show` и сравнить результат с местным временем. Если он не совпадает - ваши часы, скорее всего, используют UTC.

Создайте нужный файл, определяющий, использует ли CMOS UTC. Если не использует, то замените значение переменной `UTC` на 0.

```bash
cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
EOF
```

***

[Назад - Настройка окружения](shell.md)

[Далее - Настройка клавиатуры и шрифта в TTY](console.md)
