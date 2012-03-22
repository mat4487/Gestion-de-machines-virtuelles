#!/bin/bash
ganeti_slaves="/root/ganeti_slaves"


while read node
do
    gnt-node add $node
done < $ganeti_slaves

echo "Combien d'instances par node ?? "
read nb
b=$nb
while read line
do
    for i in `seq $a $nb`;
    do
        echo "10.0.1.$i instance$i" >> /etc/hosts
        gnt-instance add -n $line -o debootstrap+default -t plain -s 2000 instance$i
    done
    nb=`echo $(($nb + $b))`
    a=`echo $(($a + $b))`
done < ganeti_slaves