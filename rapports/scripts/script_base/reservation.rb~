#!/usr/bin/ruby -w
# -*- coding: utf-8 -*-

puts "-----------------------------------------"
puts "Souhaitez vous reserver des noeuds?(y/n)"
loop do
  test = gets.chomp
  if test.eql?("n")
    puts "#####################"
    puts "#sortie du programme#"
    puts "#####################"
    break;
  end
  if test.eql?("y")
    #Réservation de machines                                                 
    puts "---------Script de reservation-----------"
    puts "Choisir un nombre de noeud:"
    noeuds = gets.chomp.to_i
    puts "Choisir un temps de reservation(HH:MM:SS):"
    temps = gets
    puts "\nVous avez reserve #{noeuds} noeuds pour une duree de #{temps}"
    puts "-----------------------------------------"
    puts "Voulez-vous mettre les noeuds dans un vlan separe(y/n)"
loop do
  test = gets.chomp
  if test.eql?("n")
    exec "oarsub -I -t deploy -n'virtu' -l slash_22=1+nodes=#{noeuds},walltime=#{temps}"
    break;
  end
      if test.eql?("y")
        puts "-----------------------------------------"
        exec "oarsub -I -t deploy -n'virtu' -l {\"type='kavlan-local'\"}/vlan=1+/slash_22=1+nodes=#{noeuds},walltime=#{temps}"
        break;
      end
    end
    break;
  end
end
