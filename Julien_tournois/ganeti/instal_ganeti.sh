#!/bin/bash 

##################################################
#------------Installation de Ganeti--------------#
#________________________________________________#

#chargement des noeuds reserve
list_nodes="$HOME/script_base/list_nodes"

#sauvegarde le 1er noeud qui sera le maitre
sed -n "1 p" $list_nodes > $HOME/ganeti/ganeti_manager
ganeti_manager="$HOME/ganeti/ganeti_manager"

echo "############################"
echo "######Ganeti Manager########"
cat $ganeti_manager
echo "############################"

#installe ganeti par les depots
taktuk -l root -f $ganeti_manager broadcast exec [ apt-get install -q --force-yes ganeti2 ]
