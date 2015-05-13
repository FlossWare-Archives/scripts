#!/bin/sh

if [ $# -lt 1 ]
then
	echo "Please supply at least one package to install!"
	exit 1
fi

cd /tmp

for aPackage in $*
do
	wget http://ipkg.nslu2-linux.org/feeds/optware/ddwrt/cross/stable/${aPackage}
	ipkg install ${aPackage}
	rm ${aPackage}
done
