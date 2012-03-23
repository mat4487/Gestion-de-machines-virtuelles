#!/bin/bash 

##################################################
#------------Installation de Archipel------------#
#________________________________________________#

#chargement des noeuds reserve
list_nodes="$HOME/script_base/list_nodes"
list_node=`cat $HOME/script_base/list_nodes`

#sauvegarde le 1er noeud qui sera le maitre
sed -n "1 p" $list_nodes > $HOME/archipel/archipel_manager
archipel_manager="$HOME/archipel/archipel_manager"
archipel_man=`cat $HOME/archipel/archipel_manager`

#sauvegarde des noeud esclaves
cat $list_nodes | grep -v $archipel_man > $HOME/archipel/archipel_slaves
archipel_slaves="$HOME/archipel/archipel_slaves"
archipel_slav=`cat $HOME/archipel/archiel_slaves`

echo $USER > username

echo "####Archipel Manager########"
cat $archipel_manager
echo "############################"
echo "#####Archipel Slaves########"
cat $archipel_slaves
echo "############################"

#copie des fichier néssaisaire à la configuration de archipel
while read line
do  
    scp -r sources/* root@$line:/usr/local/src
    scp -r username root@$line:/usr/local/src
    scp -r config_archipel.sh root@$line:/usr/local/src
done < $list_nodes

#lancement de la configuration de archipel sur le noeud maitre
taktuk -l root -f $archipel_manager broadcast exec [ sh /usr/local/src/config_archipel.sh ]

#scp archipel_master.sh root@$archipel_man:/root/

#lancement du script d'installation de ganeti sur le manager
#taktuk -l root -f $archipel_manager broadcast exec [ sh archiepl_master.sh ]

#while read line
#do  
#    scp ganeti_slave.sh root@$line:/root/
#    taktuk -l root -f $line broadcast exec [ sh archipel_slave.sh ]
#done < archipel_slaves
