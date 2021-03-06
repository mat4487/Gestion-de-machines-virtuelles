#Ajout des sources testing pour installer la derniere version de archipel
echo "## wheezy security" >> /etc/apt/sources.list
echo "deb http://security.debian.org/ wheezy/updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://security.debian.org/ wheezy/updates main contrib non-free" >> /etc/apt/sources.list
echo " " >> /etc/apt/sources.list
echo "#wheezy" >> /etc/apt/sources.list
echo "deb http://ftp.fr.debian.org/debian/ wheezy main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://ftp.fr.debian.org/debian/ wheezy main contrib non-free" >> /etc/apt/sources.list

#Ajout du fichier de preference
echo "APT::Default-Release \"stable\";" > /etc/apt/apt.conf.d/80default-distrib

#installation des composants utils  archipel
apt-get install -t testing ejabberd erlang-dev erlang-xmerl build-essential erlang-tools python-setuptools -y --force-yes

#configuration de ejabber
cd /usr/local/src/xmlrpc-1.13/src
make

cd /usr/local/src
cp -a xmlrpc-1.13 /usr/lib/erlang/lib/

cd /usr/local/src/ejabberd-modules/ejabberd_xmlrpc/trunk/
sh build.sh
cp ebin/ejabberd_xmlrpc.beam /usr/lib/ejabberd/ebin/

cd /usr/local/src/ejabberd-modules/mod_admin_extra/trunk/
sh build.sh
cp ebin/mod_admin_extra.beam /usr/lib/ejabberd/ebin/

#suppression du fichier de conf de base
rm /etc/ejabberd/ejabberd.cfg
cp /usr/local/src/ejabberd.cfg /etc/ejabberd/
