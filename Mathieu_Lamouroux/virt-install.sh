#!/bin/bash
###########################################
## Script d'installation de virt-manager ##
###########################################

# Mise à jour du système 
apt-get update
apt-get upgrade -y

# Installation de libvirt pour communiquer avec le démon xend
apt-get install libvirt-bin -y

# Installation de qemu-dm pour créer des machines virtuelles en mode full virtualisé
apt-get install xen-qemu-dm-4.0 -y
mkdir /usr/lib64/xen
mkdir /usr/lib64/xen/bin
cd /usr/lib64/xen/bin
ln -s /usr/lib/xen-4.0/bin/qemu-dm

# Activation des sockets Unix
# (nécessaire pour la communication entre libvirt et xend)
echo "(xend-unix-server yes)" >> /etc/xen/xend-config.sxp

# Redémarrage de xend pour application des changements
/etc/init.d/xend restart

# Installation de virt-manager
apt-get install virt-manager -y

#############
# Optionnel #
#############
# Lancement du script pour le déploiement de 7 machines virtuelles
./vm.sh