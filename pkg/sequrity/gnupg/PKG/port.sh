#!/bin/bash

cd /usr/src
wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.27.tar.bz2
tar -xvf gnupg-2.2.27.tar.bz2
cd gnupg-2.2.27

sed -e '/noinst_SCRIPTS = gpg-zip/c sbin_SCRIPTS += gpg-zip' \
    -i tools/Makefile.in

./configure --prefix=/usr            \
            --localstatedir=/var     \
            --docdir=/usr/share/doc/gnupg-2.2.27 &&
make &&

makeinfo --html --no-split -o doc/gnupg_nochunks.html doc/gnupg.texi &&
makeinfo --plaintext       -o doc/gnupg.txt           doc/gnupg.texi &&
make -C doc html

make install &&

install -v -m755 -d /usr/share/doc/gnupg-2.2.27/html            &&
install -v -m644    doc/gnupg_nochunks.html \
                    /usr/share/doc/gnupg-2.2.27/html/gnupg.html &&
install -v -m644    doc/*.texi doc/gnupg.txt \
                    /usr/share/doc/gnupg-2.2.27 &&
install -v -m644    doc/gnupg.html/* \
                    /usr/share/doc/gnupg-2.2.27/html
