#!/bin/bash 

##################################################
#------------Installation de Ganeti--------------#
#________________________________________________#

#chargement des noeuds reserve
list_nodes="$HOME/script_base/list_nodes"
list_node=`cat $HOME/script_base/list_nodes`

#sauvegarde le 1er noeud qui sera le maitre
sed -n "1 p" $list_nodes > $HOME/ganeti/ganeti_manager
ganeti_manager="$HOME/ganeti/ganeti_manager"
ganeti_man=`cat $HOME/ganeti/ganeti_manager`

#sauvegarde des noeud esclaves
cat $list_nodes | grep -v $ganeti_man > $HOME/ganeti/ganeti_slaves
ganeti_slaves="$HOME/ganeti/ganeti_slaves"
ganeti_slav=`cat $HOME/ganeti/ganeti_slaves`


echo "######Ganeti Manager########"
cat $ganeti_manager
echo "############################"
echo "######Ganeti Slaves########"
cat $ganeti_slaves
echo "############################"

#récupère l'adresse du cluster1 pour l'envoyer au node x.x.x.1
g5k-subnets -i -o ip_list.txt 
ipnode=`head -1 ip_list.txt`
echo $ipnode > ipcluster

#recupere l'ip de la gateway x.x.x.254
ipgateway=`head -254 ip_list.txt | tail -1`
echo $ipgateway > ipgateway

#récupère l'ip du reseau
g5k-subnets -a > tempipreseau
ipnetwork=`head -1 tempipreseau | cut -d'/' -f1`
echo $ipnetwork > ipnetwork

#envoi via ssh au node
while read node
do
    scp common.sh node-add.sh ganeti_slaves ganeti_master.sh ganeti_slave.sh ipgateway ipnetwork ipcluster tempipreseau ip_list.txt root@$node:/root/
done < $list_nodes

#suppression des fichiers
rm ipgateway ipnetwork ipcluster tempipreseau ip_list.txt

#lancement du script d'installation de ganeti sur le manager
taktuk -l root -f $ganeti_manager broadcast exec [ sh ganeti_master.sh ]

#idem sur les eclaves
taktuk -l root -f $ganeti_slaves broadcast exec [ sh ganeti_slave.sh ]

mkdir keys
cd keys
scp root@$ganeti_man:/root/.ssh/authorized_keys .
mv authorized_keys authorized      
tail -n 1 authorized > authorized_keys && rm authorized
scp root@$ganeti_man:/root/.ssh/id_dsa* .
taktuk -l root -f $ganeti_manager broadcast exec [ rm /usr/lib/ganeti/tools/setup-ssh ]
scp setup-ssh root@$ganeti_man:/usr/lib/ganeti/tools/

while read slavenode
do
    scp id_dsa* authorized_keys root@$slavenode:/root/
done < $ganeti_slaves
rm id_dsa*
taktuk -l root -f $ganeti_slaves broadcast exec [ cp /root/authorized_keys /root/.ssh/ ]
