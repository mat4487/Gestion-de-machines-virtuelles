#!/bin/sh
echo "creation du repertoire de configuration......"
mkdir .vmconfig
cd .vmconfig
echo "done\n"
echo "creation du fichier avec l'adresse de broadcast......"
g5k-subnets -a -o brodcast.txt
echo "done\n"
echo "creation du fichier avec la liste des ip......"
g5k-subnets -i -o ip_list.txt
echo "done\n"
echo "creation du fichier avec la liste des machines attribuees......
"
cat $OAR_FILE_NODES > vms_assigned.txt
echo "done"
for vm in `cat vms_assigned.txt`
do
    echo "Configuration de $vm"
    echo "mise a jour de la machine $vm"
    ssh root@$vm "apt-get update && apt-get upgrade --yes"
done
#for vm in `cat vms_assigned_ips.txt`
#do
#    echo "mise a jour de la machine $vm"
#    ssh root@$vm "apt-get update && apt-get upgrade"
#done
