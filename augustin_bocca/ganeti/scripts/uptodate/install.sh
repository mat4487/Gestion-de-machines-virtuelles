#!/bin/bash

#VERIFIER QUE postinstall.sh et ganeti.sh soient dans le meme dossier puis executer postinstall.sh (Sur le frontend !) !


#récupère l'adresse du cluster1 pour l'envoyer au node x.x.x.1
#g5k-subnets -i -o ip_list.txt
#ipnode=`head -1 ip_list.txt`
ipnode=10.0.1.254
echo $ipnode > ipcluster

#recupere l'ip de la gateway x.x.x.254
#ipgateway=`head -254 ip_list.txt | tail -1`
ipgateway=10.0.1.253
echo $ipgateway > ipgateway

#récupère l'ip du reseau
#g5k-subnets -a > tempipreseau
#ipnetwork=`head -1 tempipreseau | cut -d'/' -f1`
ipnetwork=172.16.69.0
echo $ipnetwork > ipnetwork

#envoi via ssh au node
scp ipcluster ipgateway ipnetwork ganeti.sh common.sh root@$1:/root/

#suppression des fichiers
rm ipgateway ipnetwork ipcluster

ssh root@$1
