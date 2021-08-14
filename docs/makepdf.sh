#!/bin/bash
# Генерация PDF-версии документации
# (C) 2021 Михаил Linuxoid85 Краснов <linuxoid85@gmail.com>
# Для Calmira LX4 1.1 GNU/Linux

wkhtmltopdf https://calmiralinux.github.io/CalmiraLinux/docs/{index, \
	typo,                         \
	about,                        \
	history,                      \
	installation/{index,          \
	download,                     \
	unpack,                       \
	install_sys,                  \
	install_qemu,                 \
	setting_up,                   \
	exit},                        \
	setup/{index,                 \
	shell,                        \
	clock,                        \
	console,                      \
	inittab,                      \
	bootscripts},                 \
	packages/{intro_{ports,cpkg}, \
	make{port,pkg}},              \
	additional/{index,            \
	manifest,                     \
	gnu,                          \
	gfdl}}.html 2021.5.pdf
