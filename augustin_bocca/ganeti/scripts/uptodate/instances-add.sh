#!/bin/bash

echo "Combien d'instances par node ?? "
read nb
while read line
do
        for i in `seq $a $nb`;
        do
                echo "10.0.1.$i instance$i" >> /etc/hosts
                gnt-instance add -n $line -o debootstrap+default -t plain -s 2000 instance$i
        done
        nb=`echo $(($nb + $nb))`
#        echo "nb vaut : $nb"
#        echo "a vaut : $a"
done < ganeti_slaves
