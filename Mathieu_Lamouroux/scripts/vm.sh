#!/bin/bash
#La mise à jour doit etre effectuer avant de lancer le script 
#atp-get update && apt-get dist-upgrade

#Creation de la place pour les vm
mkdir /media/vm
umount /dev/sda5
mount /dev/sda5 /media/vm

#Création des loop pour les VMs
echo "options loop max_loop=64" > /etc/modprobe.d/xen.conf
rmmod loop
modprobe loop

#Création des fichier de config des vm
cd /etc/xen/

echo "Création des fichier de config des vm"
for i in `seq 1 7`;
do
touch domU$i.cfg
echo "#" >> /etc/xen/domU$i.cfg
echo "# Configuration file for the Xen instance domU, created"  >> /etc/xen/domU$i.cfg
echo "# by xen-tools 4.2 on Wed Jan  4 14:54:54 2012." >> /etc/xen/domU$i.cfg
echo "#" >> /etc/xen/domU$i.cfg
echo "#" >> /etc/xen/domU$i.cfg
echo "#  Kernel + memory size" >> /etc/xen/domU$i.cfg
echo "#" >> /etc/xen/domU$i.cfg
echo "kernel      = '/boot/vmlinuz-2.6.32-5-xen-amd64'" >> /etc/xen/domU$i.cfg
echo "ramdisk     = '/boot/initrd.img-2.6.32-5-xen-amd64'" >> /etc/xen/domU$i.cfg
echo "vcpus       = '1'" >> /etc/xen/domU$i.cfg
echo "memory      = '128'" >> /etc/xen/domU$i.cfg
echo "#" >> /etc/xen/domU$i.cfg
echo "#  Disk device(s)." >> /etc/xen/domU$i.cfg
echo "#" >> /etc/xen/domU$i.cfg
echo "root        = '/dev/xvda2 ro'" >> /etc/xen/domU$i.cfg
echo "disk        = [" >> /etc/xen/domU$i.cfg
echo "                        ]" >> /etc/xen/domU$i.cfg
echo "" >> /etc/xen/domU$i.cfg
echo "#" >> /etc/xen/domU$i.cfg
echo "#  Physical volumes " >> /etc/xen/domU$i.cfg
echo "#" >> /etc/xen/domU$i.cfg
echo "" >> /etc/xen/domU$i.cfg
echo "" >> /etc/xen/domU$i.cfg
echo "#" >> /etc/xen/domU$i.cfg
echo "#  Hostname" >> /etc/xen/domU$i.cfg
echo "#" >> /etc/xen/domU$i.cfg
echo "name        = 'domU$i'" >> /etc/xen/domU$i.cfg
echo "" >> /etc/xen/domU$i.cfg
echo "#" >> /etc/xen/domU$i.cfg
echo "#  Networking" >> /etc/xen/domU$i.cfg
echo "# ">> /etc/xen/domU$i.cfg
echo "vif         = [ 'ip=10.0.0.$i,mac=00:16:3E:94:B4:93' ]" >> /etc/xen/domU$i.cfg
echo "">> /etc/xen/domU$i.cfg
echo "#" >> /etc/xen/domU$i.cfg
echo "#  Behaviour" >> /etc/xen/domU$i.cfg
echo "#" >> /etc/xen/domU$i.cfg
echo "on_poweroff = 'destroy' ">> /etc/xen/domU$i.cfg
echo "on_reboot   = 'restart'" >> /etc/xen/domU$i.cfg
echo "on_crash    = 'restart'" >> /etc/xen/domU$i.cfg
done

#Copie à partir de la premiere vm
for i in `seq 1 7`;
do
    mkdir -p /media/vm/domU$i/
    cp /opt/xen/domains/domU/disk.img /media/vm/domU$i/
    cp /opt/xen/domains/domU/swap.img /media/vm/domU$i/
done


echo "xen g5k restart"
/etc/init.d/xen-g5k restart

echo "creation des vm"
for i in `seq 1 7`;
do
    xm create /etc/xen/domU$i.cfg
done
