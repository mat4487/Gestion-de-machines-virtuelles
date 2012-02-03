#!/usr/bin/ruby -w
# -*- coding: utf-8 -*-

puts "-----------------------------------------"
puts "Souhaitez vous réserver des noeuds?(y/n)"
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
    puts "---------Script de réservation-----------"
    puts "Choisir un nombre de noeud:"
    noeuds = gets.chomp.to_i
    puts "Choisir un temps de réservation(HH:MM:SS):"
    temps = gets
    puts "\nVous avez reserve #{noeuds} noeuds pour une duree de #{temps}"
    puts "-----------------------------------------"
    exec "oarsub -I -t deploy -l nodes=#{noeuds},walltime=#{temps}"
    oarstat | grep $USER |tail -1 | cut -d ' ' -f1`
    break;
  end
end
