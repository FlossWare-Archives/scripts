#!/bin/sh

/usr/bin/killall ntpd
/opt/bin/ntpdate 0.pool.ntp.org
/opt/etc/init.d/S77ntp
