#!/bin/sh

# ------------------------------------------------------
# List of useful packages:
#
#   ncurses_5.7-3_mipsel.ipk
#   screen_4.0.3-2_mipsel.ipk
#   tmux_1.6-1_mipsel.ipk
#   openssl_0.9.7m-6_mipsel.ipk
#   fetchmail_6.3.21-1_mipsel.ipk
#   rsync_3.0.9-1_mipsel.ipk
# ------------------------------------------------------

if [ $# -lt 1 ]
then
	echo "Please supply at least one package to install!"
	exit 1
fi

cd /tmp

# Need to have uclibc-opt_0.9.28-13_mipsel.ipk installed

if [ -e /opt/lib/ld-uClibc-0.9.28.so ]
then
	ALL_PACKAGES="$*"
else
	# We always want to include uclibc-opt_0.9.28-13_mipsel.ipk
	
	ALL_PACKAGES="uclibc-opt_0.9.28-13_mipsel.ipk $*"
fi

for aPackage in ${ALL_PACKAGES}
do
	wget http://ipkg.nslu2-linux.org/feeds/optware/ddwrt/cross/stable/${aPackage}
	ipkg -d ram install ${aPackage}
	rm ${aPackage}
done
