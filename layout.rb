class Layout
  def self.menu
    puts '======================'
    puts 'Nomes no Brasil - IBGE'
    puts "======================\n\n"

    puts 'Informe o número da opção que deseja consultar:'
    puts '[1] Consultar ranking dos nomes mais comuns em uma determinada Unidade Federativa (UF)'
    puts '[2] Consultar ranking dos nomes mais comuns em uma determinada cidade'
    puts '[3] Consultar frequência do uso de um nome ao longo dos anos'
    puts "[4] Sair\n\n"
  end

  def self.jump_line
    puts ''
  end

  def self.invalid_messages(id)
    if id == 0
      puts 'Opção incorreta, informe um número válido'
    elsif id == 1
      puts 'UF incorreta, digite uma UF válida'
    elsif id == 2
      puts 'Cidade não encontrada, digite um nome válido'
    elsif id == 21
      puts "\nUF inválida"
      puts 'Escolha a UF da cidade solicitada:'
    end
  end

  def self.result_not_found
    puts 'Nenhum registro encontrado.'
  end

  def self.several_cities_found(user_city)
    puts "\nForam encontradas mais de 1 cidade com o nome #{user_city}"
    puts 'Escolha a UF da cidade solicitada:'
  end

  def c
    puts "\n\nInforme qual UF deseja consultar:"
  end

  def self.title(id)
    if id == 1
      puts "\n======================================"
      puts "Informe qual UF deseja consultar:"
      puts "======================================"
      puts "Lista de UFs:\n"
    elsif id == 2
      puts "\n=============================================="
      puts "Informe o nome da cidade que deseja consultar:"
      puts "=============================================="
    elsif id == 3
      puts "\n=========================================="
      puts "Informe o(s) nome(s) que deseja consultar:"
      puts "OBS: Separar os nomes por vírgula (,)"
      puts "=========================================="
    end
  end

  def self.show_result_find_by_uf(choosen_state, json_both, json_male, json_female)
    puts "\n==========================================================================="
    puts "Ranking dos nomes mais comuns em #{choosen_state.name} (Masculino e Feminino)"
    puts "==========================================================================="
    puts "#{"RANKING".ljust(15)}#{"NOME".ljust(15)}FREQUÊNCIA"
    puts "----------------------------------------"
    json_both[0]["res"].each do |r|
      puts "#{r["ranking"].to_s.ljust(15)}#{r["nome"].ljust(15)}#{r["frequencia"].to_s.rjust(10)}"
    end

    puts "\n================================================================"
    puts "Ranking dos nomes mais comuns em #{choosen_state.name} (Masculino)"
    puts "================================================================"
    puts "#{"RANKING".ljust(15)}#{"NOME".ljust(15)}FREQUÊNCIA"
    puts "----------------------------------------"
    json_male[0]["res"].each do |r|
      puts "#{r["ranking"].to_s.ljust(15)}#{r["nome"].ljust(15)}#{r["frequencia"].to_s.rjust(10)}"
    end

    puts "\n==============================================================="
    puts "Ranking dos nomes mais comuns em #{choosen_state.name} (Feminino)"
    puts "==============================================================="
    puts "#{"RANKING".ljust(15)}#{"NOME".ljust(15)}FREQUÊNCIA"
    puts "----------------------------------------"
    json_female[0]["res"].each do |r|
      puts "#{r["ranking"].to_s.ljust(15)}#{r["nome"].ljust(15)}#{r["frequencia"].to_s.rjust(10)}"
    end
  end

  def self.show_result_find_by_city(city, json_both, json_male, json_female)
    puts "\n====================================================================="
    puts "Ranking dos nomes mais comuns em #{city.name} (Masculino e Feminino)"
    puts "====================================================================="
    puts "#{"RANKING".ljust(15)}#{"NOME".ljust(15)}FREQUÊNCIA"
    puts "----------------------------------------"
    json_both[0]["res"].each do |r|
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
  end

  def self.show_result_find_by_name(json, decade_keys, final_hash)
    header = json.map { |reg| reg['nome'].rjust(15) }.join('')
    puts "\n\n==================================================================="
    puts "Frequência ao longo dos anos dos nomes: '#{json.map { |reg| reg['nome'] }.join(', ')}'"
    puts "==================================================================="

    puts "--------------------------------------------------------------------"
    puts "#{'DECADA'.rjust(10)}#{header}"
    puts '--------------------------------------------------------------------'

    decade_keys.sort.each do |decade|
      formatted_decade = decade.gsub('[', '').rjust(10)
      frequencies = final_hash.map { |col| col[1][decade].to_s.rjust(15) }.join
      puts "#{formatted_decade}#{frequencies}"
    end
  end
end