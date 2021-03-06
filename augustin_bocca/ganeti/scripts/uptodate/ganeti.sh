#!/bin/bash

##VERIFIER QUE postinstall.sh et ganeti.sh soient dans le meme dossier puis executer postinstall.sh (Sur le frontend)!

#Ajout des sources testing pour installer la derniere version de ganeti
echo "## wheezy security" >> /etc/apt/sources.list
echo "deb http://security.debian.org/ wheezy/updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://security.debian.org/ wheezy/updates main contrib non-free" >> /etc/apt/sources.list
echo " " >> /etc/apt/sources.list
echo "#wheezy" >> /etc/apt/sources.list
echo "deb http://ftp.fr.debian.org/debian/ wheezy main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://ftp.fr.debian.org/debian/ wheezy main contrib non-free" >> /etc/apt/sources.list

#Ajout du fichier de preference
echo "APT::Default-Release \"stable\";" > /etc/apt/apt.conf.d/80default-distrib

#Installation de ganeti 
apt-get update && apt-get dist-upgrade -q -y --force-yes
apt-get -t testing install -q -y --force-yes ganeti2 ganeti-htools ganeti-instance-debootstrap

echo "Ajout du node dans /etc/hosts"
hostname=`cat /etc/hostname`

#recuperation des variables

#ip du node
ifconfig eth0 > troll
ipnode=`head -2 troll | tail -1 | cut -d':' -f2 | cut -d' ' -f1`
echo $ipnode " " $hostname >> /etc/hosts

#ip du broadcast
ipbroadcast=`head -2 troll | tail -1 | cut -d'B' -f2 | cut -d':' -f2 | cut -d' ' -f1`

#ip du masque de sous réseau
ipmask=`head -2 troll | tail -1 | cut -d'M' -f2 | cut -d':' -f2 | cut -d' ' -f1`

#ip du reseau
ipnetwork=`head -1 ipnetwork`

#ip de la passerelle
ipgateway=`head -1 ipgateway`

#ajout de cluster1 dans /etc/hosts
echo "ajout de cluster1 dans /etc/hosts"
ipcluster=`cat ipcluster`
echo $ipcluster "cluster1" >> /etc/hosts

#Dans /boot/ creer des liens symboliques :
cd /boot
cp vmlinuz-2.6.32-5-xen-amd64 vmlinuz-2.6-xenU
cp initrd.img-2.6.32-5-xen-amd64 initrd.img-2.6-xenU

#Pour le moment changera surement.
echo "creation du LVM"
umount /dev/sda5
pvcreate /dev/sda5
vgcreate xenvg /dev/sda5

#Creation du bridge xen-br0
echo " " >> /etc/network/interfaces
echo "auto xen-br0"  >> /etc/network/interfaces
echo "iface xen-br0 inet static" >> /etc/network/interfaces
echo "address" $ipnode >> /etc/network/interfaces
echo "netmask " $ipmask >> /etc/network/interfaces
echo "network" $ipnetwork >> /etc/network/interfaces
echo "gateway"  $ipgateway >> /etc/network/interfaces
echo "broadcast" $ipbroadcast>> /etc/network/interfaces
echo "bridge_ports eth0" >> /etc/network/interfaces
echo "bridge_stp off" >> /etc/network/interfaces
echo "bridge_fd 0" >> /etc/network/interfaces

#Suppression des ligne de eth0
sed -i '9d' /etc/network/interfaces
sed -i '9d' /etc/network/interfaces

#Redemarage du network
/etc/init.d/networking stop
/etc/init.d/networking start

#supression des fichier temporaires et copie de common.sh
cd /root/
rm troll ipcluster  ipgateway  ipnetwork
rm /usr/share/ganeti/os/debootstrap/common.sh
mv common.sh /usr/share/ganeti/os/debootstrap/

#initialisation du cluster
gnt-cluster init --no-drbd-storage --nic-parameters link=eth0 cluster1

#et verifier
gnt-node list

#renseigner le inird pour les instances et le root_path
gnt-cluster modify --hypervisor-parameter xen-pvm:initrd_path='/boot/initrd.img-2.6-xenU'
gnt-cluster modify --hypervisor-parameter xen-pvm:root_path='/dev/xvda1'
