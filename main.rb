require 'faraday'
require 'json'
require 'pry'
require './config/database_connection'
require './city'
require './state'

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
  puts "\nInforme o nome da cidade que deseja consultar:"
  user_city = gets.chomp.upcase

  city = City.where(name: user_city)

  while city.empty?
    puts 'Cidade não encontrada, digite um nome válido'
    user_city = gets.chomp.upcase
    city = City.where(name: user_city)
  end

  if city.size > 1
    puts "\nForam encontradas mais de 1 cidade com o nome #{user_city}"
    puts 'Escolha a UF da cidade solicitada:'

    city.each { |c| print "#{c.initial} " }
    puts ''
    user_initial = gets.chomp.upcase

    until city.pluck(:initial).include?(user_initial)
      puts "\nUF inválida"
      puts 'Escolha a UF da cidade solicitada:'
      city.each { |c| print "#{c.initial} " }
      puts ''
      user_initial = gets.chomp.upcase
    end

    city = City.where(name: user_city, initial: user_initial)
  end

  city = city.first

  table_all = Faraday.get(
    "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{city.code}"
  )
  table_male = Faraday.get(
    "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{city.code}&sexo=M"
  )
  table_female = Faraday.get(
    "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{city.code}&sexo=F"
  )

  json_all = JSON.parse(table_all.body)
  json_male = JSON.parse(table_male.body)
  json_female = JSON.parse(table_female.body)

  puts "\n====================================================================="
  puts "Ranking dos nomes mais comuns em #{city.name} (Masculino e Feminino)"
  puts "====================================================================="
  puts "#{"RANKING".ljust(15)}#{"NOME".ljust(15)}FREQUÊNCIA"
  puts "----------------------------------------"
  json_all[0]["res"].each do |r|
    puts "#{r["ranking"].to_s.ljust(15)}#{r["nome"].ljust(15)}#{r["frequencia"].to_s.rjust(10)}"
  end

  puts "\n=========================================================="
  puts "Ranking dos nomes mais comuns em #{city.name} (Masculino)"
  puts "=========================================================="
  puts "#{"RANKING".ljust(15)}#{"NOME".ljust(15)}FREQUÊNCIA"
  puts "----------------------------------------"
  json_male[0]["res"].each do |r|
    puts "#{r["ranking"].to_s.ljust(15)}#{r["nome"].ljust(15)}#{r["frequencia"].to_s.rjust(10)}"
  end

  puts "\n========================================================="
  puts "Ranking dos nomes mais comuns em #{city.name} (Feminino)"
  puts "========================================================="
  puts "#{"RANKING".ljust(15)}#{"NOME".ljust(15)}FREQUÊNCIA"
  puts "----------------------------------------"
  json_female[0]["res"].each do |r|
    puts "#{r["ranking"].to_s.ljust(15)}#{r["nome"].ljust(15)}#{r["frequencia"].to_s.rjust(10)}"
  end

elsif option == '3'
  puts "\nInforme o(s) nome(s) que deseja consultar:"
  puts "OBS: Separar os nomes por vírgula (,)"

  names = gets.chomp.downcase
  names = names.gsub(' ', '').gsub(',', '%7C')

  table = Faraday.get(
    "https://servicodados.ibge.gov.br/api/v2/censos/nomes/#{names}"
  )

  json = JSON.parse(table.body)

  if json.empty?
    puts 'Nenhum registro encontrado.'
  else
    decade_keys = json.map {|r| r['res'].map {|x| x['periodo'] }}.flatten.uniq
    decade_hash = Hash[decade_keys.zip]

    decade_hash.each do |key, _value|
      decade_hash[key] = 0
    end

    final_hash = {}
    names_array = json.map {|name_data| name_data['nome']}
    names_array.each do |name|
      final_hash[name] = decade_hash.clone
    end

    json.each do |name_data|
      name_data['res'].each do |data|
        final_hash[name_data['nome']][data['periodo']] = data['frequencia']
      end
    end

    header = json.map { |reg| reg['nome'].rjust(15) }.join('')
    puts "\n#{'DECADA'.rjust(10)}#{header}"

    decade_keys.sort.each do |decade|
      formatted_decade = decade.gsub('[', '').rjust(10)
      frequencies = final_hash.map { |col| col[1][decade].to_s.rjust(15) }.join
      puts "#{formatted_decade}#{frequencies}"
    end
  end

elsif option == '4'
  return
end
