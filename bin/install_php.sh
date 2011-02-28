#!/bin/bash
if [ "$(basename $0)" != "install_all.sh" ]; then
    source ${0%/*}/config.sh
fi

install_php()
{
    xprepare $php

    mysql_install=$srv_bin/mysql
    php_install=$srv_bin/$CURRENT_PACKAGE

    ln -s $mysql_install/lib/libmysqlclient.so.16 /usr/lib/
    
    gzip -cd $cache_dir/$(xpackage $php_fpm) | patch -d . -p1
    xcheck "应用 php_fpm 补丁" $?

    ./configure --prefix=${php_install} --with-config-file-path=${php_install}/etc --with-mysql=${mysql_install} --with-mysqli=${mysql_install}/bin/mysql_config --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-discard-path --enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fastcgi --enable-fpm --enable-force-cgi-redirect --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-ldap --with-ldap-sasl --with-xmlrpc --enable-zip --enable-soap
    xcheck "conf" $?

    make ZEND_EXTRA_LIBS='-liconv'
    xcheck "make" $?

    make install
    xcheck "make install" $?

    xbackup_if_exist $srv_bin/php
    ln -s $php_install $srv_bin/php
    xcheck "link to php" $?

    # cp ${dbuild}/${php_pkg}/php.ini-dist ${php_install}/etc/php.ini
}

install_php | tee -a $install_log
