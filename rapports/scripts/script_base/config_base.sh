#!/bin/bash

########################################################
#------------------Configuration minimale--------------#
#______________________________________________________#

config_ssh () {
#ajoute les ligner permettant la connexion a un kvlan
Echo "Host *-*-kavlan-1 *-*-kavlan-1.*.grid5000.fr"
echo "ProxyCommand ssh -a -x kavlan-1 nc -q 0 %h %p"
echo "Host *-*-kavlan-2 *-*-kavlan-2.*.grid5000.fr"
echo "ProxyCommand ssh -a -x kavlan-2 nc -q 0 %h %p"
echo "Host *-*-kavlan-3 *-*-kavlan-3.*.grid5000.fr"
echo "ProxyCommand ssh -a -x kavlan-3 nc -q 0 %h %p"
}

#Verification et configuration SSH de l'utilisateur
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
##On regarde si le fichier .ssh existe
echo "---"
echo "Verification de la configuration ssh de l'utilisateur "$USER

trouver=0

if [ -f $HOME/.ssh/config ]
then 
        trouver=1
        for line in $(cat $HOME/.ssh/config)
        do
                if [ $line = "kavlan-$vlan" ]
                then
                        trouver=2
                fi
        done
else 
        echo "Erreur. Aucun fichier, .ssh/config, n'a pas été trouvé..."
        echo "Arrêt de l'installation."
        exit
fi
if [ $trouver -eq 1 ]
then 
        echo "Ajout des lignes de 'transparence'"
        config_ssh >> $HOME/.ssh/config
fi

echo "-----------------------------------------"
echo "Vos noeuds sont dans un kavlan?(y/n)"
read choix
if [ $choix == "n" ]
then
        #suppression des know_host
	rm $HOME/.ssh/known_hosts
        #Recuperation des noeuds reserves
	cat $OAR_FILE_NODES | uniq  > $HOME/script_base/list_nodes
	list_nodes="$HOME/script_base/list_nodes"

	echo "-----------------------------------"
	echo "Liste des machines reservee:"
	cat $list_nodes
	echo "-----------------------------------"
	echo "Copie des clees SSH vers toutes les machines."
	cat $HOME/.ssh/id_dsa.pub >> $HOME/.ssh/authorized_keys
	for node in $(cat $list_nodes)
	do
	    scp $HOME/.ssh/id_* root@$node:~/.ssh/
            taktuk -l root -s -m $node broadcast exec [ 'cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys' ] 
	done
	echo "-----------------------------------"

else
    #recuperation des noeuds reserves
	kavlan -l > list_nodes_kavlan
	list_nodes_kavlan="$HOME/script_base/list_nodes_kavlan"

	echo "-----------------------------------"
	echo "Liste des machines reservee:"
	cat $list_nodes_kavlan
	echo "-----------------------------------"
	echo "Copie des clees SSH vers toutes les machines."
	for node in $(cat $list_nodes_kavlan)
	do
	scp $HOME/.ssh/id_rsa* root@$node:~/.ssh/
	done
	echo "-----------------------------------"

	#changement des mdp root
	taktuk -l root -f $list_nodes_kavlan broadcast exec [ 'echo -e "pttvirtu\npttvirtu" | passwd root' ]
fi


