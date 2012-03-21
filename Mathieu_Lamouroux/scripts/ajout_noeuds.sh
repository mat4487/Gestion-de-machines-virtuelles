#!/bin/bash
###########################################################
# Virt-manager se configure via le gestionnaire gconf.
# On a donc opté pour la réécriture complète du fichier
# %gconf.xml
# Il est nécessaire d'attendre 1 min après la fermeture
# de virt-manager pour que le chemin de gconf soit crée
###########################################################

# On récupère la liste des noeuds réservés (copié par scp)
list_nodes="$HOME/list_nodes"
echo "Création du fichier de config"

fichier=".gconf/apps/virt-manager/connections/%gconf.xml"

# Sauvegarde de l'ancien fichier de configuration
mv $fichier .gconf/apps/virt-manager/connections/%gconf.xml.BACKUP

# Création du nouveau fichier
touch $fichier
echo "...................................OK"
echo "Génération de l'entete"
echo '<?xml version="1.0"?>' >> $fichier
echo '<gconf>' >> $fichier
echo ' <entry name="autoconnect" mtime="1332080750" type="list" ltype="string">
' >> $fichier
echo '  <li type="string">' >> $fichier
echo '<stringvalue>xen:///</stringvalue>' >> $fichier
echo '</li>' >> $fichier
echo '</entry>' >> $fichier
echo '<entry name="uris" mtime="1332080863" type="list" ltype="string">' >> $fichier
echo "...................................OK"
echo "ajout des noeuds"

#Pour chaque noeud réservé, on ajoute une entrée dans le fichier
for node in $(cat $list_nodes)
do
    echo '<li type="string">' >> $fichier
    echo "<stringvalue>xen+ssh://root@$node/</stringvalue>" >> $fichier
    echo '</li>' >> $fichier
done

echo "...................................OK"
echo "Génération de la fin du fichier"
echo '<li type="string">' >> $fichier
echo ' <stringvalue>xen:///</stringvalue>' >> $fichier
echo '</li>' >> $fichier
echo '</entry>' >> $fichier
echo '</gconf>' >> $fichier
echo "...................................OK"
echo "Vous pouvez relancer virt-manager"