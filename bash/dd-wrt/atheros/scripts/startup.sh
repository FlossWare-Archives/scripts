#/bin/sh

sleep 5


#mount -o bind /mnt/sda1/jffs/ /jffs

mount -o bind /mnt/sda1/etc   /etc
mount -o bind /mnt/sda1/opt   /opt
mount -o bind /mnt/sda1/root  /tmp/root

nvram get sshd_authorized_keys > /tmp/root/.ssh/authorized_keys

export LD_LIBRARY_PATH='/opt/lib:/opt/usr/lib:/lib:/usr/lib' 
export PATH='/opt/bin:/opt/usr/bin:/opt/sbin:/opt/usr/sbin:/bin:/sbin:/usr/sbin:/usr/bin'
