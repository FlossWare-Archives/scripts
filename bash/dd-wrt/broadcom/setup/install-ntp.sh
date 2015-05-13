#!/bin/sh

`dirname $0`/optware-ipkg.sh ntp_4.2.6.2-2_mipsel.ipk

cp `dirname $0`/etc/ntp/ntp.conf /opt/etc/ntp

/usr/bin/killall ntpd
/opt/bin/ntpdate 0.pool.ntp.org
/opt/etc/init.d/S77ntp
