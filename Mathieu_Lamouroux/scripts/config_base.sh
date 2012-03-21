#!/bin/bash

# On récupère la liste des noeuds réservés et on les stocke dans list_nodes
cat $OAR_FILE_NODES | sort -u  > $HOME/list_nodes
list_nodes="$HOME/list_nodes"

# Rappel des machines réservés
echo "-----------------------------------"
echo "Liste des machines reservee:"
cat $list_nodes
echo "-----------------------------------"
echo "Copie des fichiers vers toutes les machines."
for node in $(cat $list_nodes)
do
    # Copie des clefs ssh sur chaque noeud pour faciliter les communications 
	scp $HOME/.ssh/id_rsa* root@$node:~/.ssh/
    # Copie du script d'ajout de 7 vm au noeud
	scp $HOME/vm.sh root@$node:~/
    # Copie du script d'installation de virt-manager
	scp $HOME/virt-install.sh root@$node:~/
    # Copie de la liste des noeuds sur chacun des noeuds
	scp $HOME/list_nodes root@$node:~/
    # Copie d'un fichier de configuration de xend
	scp $HOME/xend-config.sxp root@$node:~/
    # Copie du script ajoutant automatiquement les noeuds à virt-manager
	scp $HOME/ajout_noeuds.sh root@$node:~/	
done
echo "-----------------------------------"

# Mise à jour des paquets sur les noeuds
echo "Mise a jour des noyaux"
taktuk -l root -f $list_nodes broadcast exec [ apt-get update ]
taktuk -l root -f $list_nodes broadcast exec [ apt-get upgrade -y ]
taktuk -l root -f $list_nodes broadcast exec [ apt-get dist-upgrade -y ]

# Changement des mdp root
taktuk -l root -f $list_nodes broadcast exec [ 'echo -e "pttvirtu\npttvirtu" | passwd root' ]

# On s'assure que les droits sont bien positionnés sur les différents scripts
taktuk -l root -f $list_nodes broadcast exec [ chmod 777 vm.sh ]
taktuk -l root -f $list_nodes broadcast exec [ chmod 777 virt-install.sh ]

echo "Lancement des scripts d'initialisation"
taktuk -l root -f $list_nodes broadcast exec [ bash vm.sh ]
taktuk -l root -f $list_nodes broadcast exec [ bash virt-install.sh ]

# On ajoute la clef aux clefs autorisees sur chaque noeud
taktuk -l root -f $list_nodes broadcast exec [ cat .ssh/id_rsa.pub >> .ssh/authorized_keys ]

# Une fois que taktuk s'est connecté sur tous les noeuds, le fichier known_host contient les signatures de tous les noeuds.
# On le copie donc partout pour éviter de valider lors de l'ajout d'une nouvelle connexion (ce qui provoquait un message d'erreur sous virt-manager)
for node in $(cat $list_nodes)
do
	scp $HOME/.ssh/known_hosts root@$node:~/.ssh/known_hosts
done