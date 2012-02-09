#!/bin/bash

cat $OAR_FILE_NODES | sort -u  > $HOME/script/list_nodes
list_nodes="$HOME/script/list_nodes"

echo "-----------------------------------"
echo "Liste des machines reservee:"
cat $list_nodes
echo "-----------------------------------"
echo "Copie des clees SSH vers toutes les machines."
for node in $(cat $list_nodes)
do
	scp $HOME/.ssh/id_rsa* root@$node:~/.ssh/
done
echo "-----------------------------------"

#mise a jour des noyaux
taktuk -l root -f $list_nodes broadcast exec [ apt-get update ]
taktuk -l root -f $list_nodes broadcast exec [ apt-get dist-upgrade ]
#changement des mdp root
taktuk -l root -f $list_nodes broadcast exec [ 'echo -e "pttvirtu\npttvirtu" | passwd root' ]

#paquets-perso
taktuk -l root -f $list_nodes broadcast exec [ apt-get install emacs23-nox ]