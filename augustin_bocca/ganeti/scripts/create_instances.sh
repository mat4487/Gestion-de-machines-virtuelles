#!/bin/bash

#Pour l'instant les instances ne sont crées que sur un node, dans le futur peut etre faudra t-il les créer sur 2 nodes. Pour cela la commande gnt-instance add -n node1:node2

echo "création d'instances pour ganeti."

#récupération du hostname.
hostname=`cat /etc/hostname`

#Création ajout dans le fichier /etc/hosts et création des instances ganeti.
for i in `seq 1 7`;
do
    echo "10.0.0.$i instance$i" >> /etc/hosts
    gnt-instance add -n $hostname -o debootstrap+default -t plain -s 15 instance$i
done
    
