require 'faraday'
require 'json'
require 'pry'

UF_LIST = {"RO": 11, "AC": 12, "AM": 13, "RR": 14, "PA": 15, "AP": 16, "TO": 17,
          "MA": 21, "PI": 22, "CE": 23, "RN": 24, "PB": 25, "PE": 26, "AL": 27,
          "SE": 28, "BA": 29, "MG": 31, "ES": 32, "RJ": 33, "SP": 35, "PR": 41,
          "SC": 42, "RS": 43, "MS": 50, "MT": 51, "GO": 52, "DF": 53}

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
  puts "\nLista de UF"

  UF_LIST.keys.each(&:to_s).sort.each { |uf| print "#{uf} " }

  puts "\n\nInforme qual UF deseja consultar:"
  user_uf = gets.chomp.upcase

  until UF_LIST.keys.include?(user_uf.to_sym)
    puts 'UF incorreta, digite uma UF válida'
    user_uf = gets.chomp.upcase
    puts ''
  end

  locality_code = UF_LIST.fetch(user_uf.to_sym)
  table_all = Faraday.get(
    "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{locality_code}"
  )
  table_male = Faraday.get(
    "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{locality_code}&sexo=M"
  )
  table_female = Faraday.get(
    "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{locality_code}&sexo=F"
  )

  json_all = JSON.parse(table_all.body)
  json_male = JSON.parse(table_male.body)
  json_female = JSON.parse(table_female.body)

  puts "\n=========================================================="
  puts "Ranking dos nomes mais comuns em #{user_uf} (Masculino e Feminino)"
  puts "=========================================================="
  puts "#{"RANKING".ljust(15)}#{"NOME".ljust(15)}FREQUÊNCIA"
  puts "----------------------------------------"
  json_all[0]["res"].each do |r|
    puts "#{r["ranking"].to_s.ljust(15)}#{r["nome"].ljust(15)}#{r["frequencia"].to_s.rjust(10)}"
  end

  puts "\n==============================================="
  puts "Ranking dos nomes mais comuns em #{user_uf} (Masculino)"
  puts "==============================================="
  puts "#{"RANKING".ljust(15)}#{"NOME".ljust(15)}FREQUÊNCIA"
  puts "----------------------------------------"
  json_male[0]["res"].each do |r|
    puts "#{r["ranking"].to_s.ljust(15)}#{r["nome"].ljust(15)}#{r["frequencia"].to_s.rjust(10)}"
  end

  puts "\n=============================================="
  puts "Ranking dos nomes mais comuns em #{user_uf} (Feminino)"
  puts "=============================================="
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