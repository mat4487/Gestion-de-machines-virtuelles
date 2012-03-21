# -*- coding: utf-8 -*-
#!/usr/bin/ruby -w

#Deployer une image cree
puts "Voulez vous deployer une image?(y/n)"
loop do
  test = gets.chomp
  if test.eql?("n")
    break;
  end
  if test.eql?("y")
    #choix de l'image                                                                                                                 
    puts "-----------------------------------------------"
    puts "image disponibles:"
    puts `ls | grep .env`
    puts "-----------------------------------------------"
    puts "Choix de la distibution(tout saisir):"
    debian = gets.chomp
    puts "-----------------------------------------------"
    puts "Voulez-vous deploye dans un vlan separe(y/n)"
    loop do
      test = gets.chomp
      if test.eql?("n")
        puts "-------------------------------------------"
        exec"kadeploy3 -f $OAR_FILE_NODES -a #{debian} -k $HOME/.ssh/id_rsa.pub"
        break;
      end
      if test.eql?("y")
        puts "-----------------------------------------------"
        vlan = `kavlan -V`
        exec"kadeploy3 -f $OAR_FILE_NODES -a #{debian} --vlan #{vlan} -d -k $HOME/.ssh/id_rsa.pub"
        break;
      end
    end
    break;
  end
end

######################################################

#Deploiment de l'environement sur les noeuds reserves                          
puts "Voulez vous deployer un environement?(y/n)"
loop do
  test = gets.chomp
  if test.eql?("n")
    puts "#####################"
    puts "#sortie du programme#"
    puts "#####################"
    break;
  end
  if test.eql?("y")                                                            
    #choix de la version a deployer                                                                                                                     
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
    puts "Choix de la version de la distribution a deployee (sans #{debian}):"
    version = gets.chomp
    version = debian+version
    puts "version utilisee:"
    puts version
    puts "-----------------------------------------------"
    puts "Voulez-vous deploye dans un vlan separe(y/n)"
    loop do
      test = gets.chomp
      if test.eql?("n")
        #choix de la version à deployer                                                                                                                  
        puts "-----------------------------------------------"
        exec"kadeploy3 -e #{version} -f $OAR_FILE_NODES -k $HOME/.ssh/id_rsa.pub"
        break;
      end
      if test.eql?("y")
        puts "-----------------------------------------------"
        vlan = `kavlan -V`
        exec"kadeploy3 -e #{version} -f $OAR_FILE_NODES --vlan #{vlan} -k $HOME/.ssh/id_rsa.pub"
        break;
      end
    end
    break;
  end
end



