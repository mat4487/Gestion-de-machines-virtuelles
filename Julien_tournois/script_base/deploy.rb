# -*- coding: utf-8 -*-
#!/usr/bin/ruby -w

#Deployer une image cree
puts "Voulez vous d?ployer une image?(y/n)"
loop do
  test = gets.chomp
  if test.eql?("n")
    puts "#####################"
    puts "#sortie du programme#"
    puts "#####################"
    break;
  end
  if test.eql?("y")
    #choix de l'image                                                                                                                 
    puts "-----------------------------------------------"
    puts "image disponibles:"
    puts `ls /home/$USER/image | grep .env`
    puts "-----------------------------------------------"
    puts "Choix de la distibution(tout saisir):"
    debian = gets.chomp
    puts "-----------------------------------------------"
    exec"kadeploy3 -f $OAR_FILE_NODES -a #{debian} -k $HOME/.ssh/id_rsa.pub"
    break;
  end
end

#Déploiment de l'environement sur les noeuds réservés                          
puts "Voulez vous déployer un environement?(y/n)"
loop do
  test = gets.chomp
  if test.eql?("n")
    puts "#####################"
    puts "#sortie du programme#"
    puts "#####################"
    break;
  end
  if test.eql?("y")                                                            
    #choix de la version à déployer                                            
    puts "-----------------------------------------------"
    puts "distributions disponibles:"
    puts `kaenv3 -l | cut -d - -f1 | uniq | tail -n +3`
    puts "-----------------------------------------------"
    puts "Choix de la distibution:"
    debian = gets.chomp
    puts "-----------------------------------------------"
    puts "version de la distribution:"
    puts `kaenv3 -l | grep #{debian}| cut -d ' ' -f1`
    debian = debian+"-x64-"
    puts "-----------------------------------------------"
    puts "Choix de la version de la distribution a déployée (sans #{debian}):"
    version = gets.chomp
    version = debian+version
    puts version
    exec"kadeploy3 -e #{version} -f $OAR_FILE_NODES -k $HOME/.ssh/id_rsa.pub"
    break;
  end
end



