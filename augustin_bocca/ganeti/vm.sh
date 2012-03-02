#!/bin/bash

#Création des loop pour les VMs (A supprimer pour adaptation)
options loop max_loop=64 > /etc/modprobe.d/xen.conf
modprobe loop


#Ce script créer des vm sur le LVM créer plutot.
#Mountage du LVM dans /media/vm (A supprimer pour adaptation)
lvcreate -L10000 -n vm xenvg
mkfs.ext4 /dev/xenvg/vm
mkdir -p /media/vm
mount /dev/xenvg/vm /media/vm


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
echo "                  'file:/media/vm/domU$i/swap.img,xvda1,w', 'file:/media/vm/domU$i/disk.img,xvda2,w' " >> /etc/xen/domU$i.cfg
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

#Copie à partir de la premiere vm (A adapter, changer /media/vm/domU$i par monchemin/domU$i la où seront stockées les disques des vm. Dans la partion sda5 /tmp ca à l'air pas mal)
echo "copie des disk"
for i in `seq 1 7`;
do
    mkdir -p /media/vm/domU$i/
    cp /opt/xen/domains/domU1/disk.img /media/vm/domU$i/
    cp /opt/xen/domains/domU1/swap.img /media/vm/domU$i/
done


echo "xen g5k restart"
/etc/init.d/xen-g5k restart

echo "creation des vm"
for i in `seq 1 7`;
do
    xm create /etc/xen/domU$i.cfg
done


