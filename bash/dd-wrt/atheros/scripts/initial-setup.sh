#/bin/sh

# ----------------------------------

cd /mnt/sda1
mkdir etc opt root 
chmod 755 etc opt root 

mkdir opt/lib 
chmod 755 opt/lib 

cp -a /etc/* /mnt/sda1/etc/ 

mount -o bind /mnt/sda1/etc /etc 
mount -o bind /mnt/sda1/opt /jffs 

mkdir -p /mnt/sda1/root

# ----------------------------------

cd /tmp
wget http://downloads.openwrt.org/snapshots/trunk/ar71xx/packages/libc_0.9.33.2-1_ar71xx.ipk 
wget http://downloads.openwrt.org/snapshots/trunk/ar71xx/packages/opkg_9c97d5ecd795709c8584e972bfdf3aee3a5b846d-6_ar71xx.ipk

ipkg install libc_0.9.33.2-1_ar71xx.ipk
ipkg install opkg_9c97d5ecd795709c8584e972bfdf3aee3a5b846d-6_ar71xx.ipk

# ----------------------------------

cp /mnt/sda1/scripts/opkg.conf /etc
cp /mnt/sda1/scripts/.profile /mnt/sda1/root

# ----------------------------------

mount -o bind /mnt/sda1/root /tmp/root 
mount -o bind /mnt/sda1/opt /opt 

export LD_LIBRARY_PATH='/opt/lib:/opt/usr/lib:/lib:/usr/lib' 

# ----------------------------------

opkg update
