require 'faraday'
require 'json'
require 'pry'
require './database'

puts '======================'
puts 'Nomes no Brasil - IBGE'
puts "======================\n\n"

puts 'Informe o número da opção que deseja consultar:'
puts '[1] Consultar ranking dos nomes mais comuns em uma determinada Unidade Federativa (UF)'
puts '[2] Consultar ranking dos nomes mais comuns em uma determinada cidade'
puts '[3] Consultar frequência do uso de um nome ao longo dos anos'
puts "[4] Sair\n\n"

option = gets.chomp

until option == '1' || option == '2' || option == '3' || option == '4'
  puts 'Opção incorreta, informe um número válido'
  option = gets.chomp
  puts ''
end

if option == '1'
  puts "\nLista de UF:"
  states = State.all.pluck(:initial).sort
  states.each { |initial| print "#{initial} " }

  puts "\n\nInforme qual UF deseja consultar:"
  user_state = gets.chomp.upcase

  until states.include?(user_state)
    puts 'UF incorreta, digite uma UF válida'
    user_state = gets.chomp.upcase
    puts ''
  end

  choosen_state = State.find_by(initial: user_state)
  table_all = Faraday.get(
    "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{choosen_state.code}"
  )
  table_male = Faraday.get(
    "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{choosen_state.code}&sexo=M"
  )
  table_female = Faraday.get(
    "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{choosen_state.code}&sexo=F"
  )

  json_all = JSON.parse(table_all.body)
  json_male = JSON.parse(table_male.body)
  json_female = JSON.parse(table_female.body)

  puts "\n====================================================================="
  puts "Ranking dos nomes mais comuns em #{choosen_state.name} (Masculino e Feminino)"
  puts "====================================================================="
  puts "#{"RANKING".ljust(15)}#{"NOME".ljust(15)}FREQUÊNCIA"
  puts "----------------------------------------"
  json_all[0]["res"].each do |r|
    puts "#{r["ranking"].to_s.ljust(15)}#{r["nome"].ljust(15)}#{r["frequencia"].to_s.rjust(10)}"
  end

  puts "\n=========================================================="
  puts "Ranking dos nomes mais comuns em #{choosen_state.name} (Masculino)"
  puts "=========================================================="
  puts "#{"RANKING".ljust(15)}#{"NOME".ljust(15)}FREQUÊNCIA"
  puts "----------------------------------------"
  json_male[0]["res"].each do |r|
    puts "#{r["ranking"].to_s.ljust(15)}#{r["nome"].ljust(15)}#{r["frequencia"].to_s.rjust(10)}"
  end

  puts "\n========================================================="
  puts "Ranking dos nomes mais comuns em #{choosen_state.name} (Feminino)"
  puts "========================================================="
  puts "#{"RANKING".ljust(15)}#{"NOME".ljust(15)}FREQUÊNCIA"
  puts "----------------------------------------"
  json_female[0]["res"].each do |r|
    puts "#{r["ranking"].to_s.ljust(15)}#{r["nome"].ljust(15)}#{r["frequencia"].to_s.rjust(10)}"
  end

elsif option == '2'

elsif option == '3'

elsif option == '4'
  return
end