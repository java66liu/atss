#!/bin/bash
# 预测解压路径
xpath() {
    for line in $(tar tf $1); do
        [ "${line//\//}" != $line ] && break
    done
    echo $line | sed "s/^\([^/]*\)\(.*\)$/\1/"
}

yum -y upgrade

yum -y install \
    gcc gcc-c++ autoconf \
    glib2-devel openssl openssl-devel \
    ncurses ncurses-devel \
    curl curl-devel libxml2 libxml2-devel \
    libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel \
    openldap openldap-devel nss_ldap openldap-clients openldap-servers \
    e2fsprogs e2fsprogs-devel \
    ntp screen

ntpdate us.pool.ntp.org

# 安装 git
/sbin/ldconfig
cd /tmp
[[ -e "git-latest.tar.gz" ]] || wget "http://www.codemonkey.org.uk/projects/git-snapshots/git/git-latest.tar.gz"

package=git-latest.tar.gz
predict=$(xpath $package)
tar xzvf $package
cd $predict
autoconf
./configure --with-curl=/usr/local
make
make install

# .gitconfig
