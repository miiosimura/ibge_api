require './layout'
require './ibge_api'

class Interface
  def self.start
    show_menu
  end

  def self.show_menu
    Layout.menu
    get_and_validate_option
  end

  def self.get_and_validate_option
    option = gets.chomp

    until option == '1' || option == '2' || option == '3' || option == '4'
      Layout.invalid_messages(0)
      option = gets.chomp
      Layout.jump_line
    end

    if option == '1'
      find_by_uf
    elsif option == '2'
      find_by_city
    elsif option == '3'
      find_by_name
    end
  end

  def self.find_by_uf
    Layout.title(1)
    states = State.all.pluck(:initial).sort
    states.each { |initial| print "#{initial} " }
    Layout.jump_line
    user_state = gets.chomp.upcase

    until states.include?(user_state)
      Layout.invalid_messages(1)
      user_state = gets.chomp.upcase
      Layout.jump_line
    end

    choosen_state = State.find_by(initial: user_state)

    table_both = IbgeApi.request_find_by_uf(choosen_state, 'both')
    table_male = IbgeApi.request_find_by_uf(choosen_state, 'male')
    table_female = IbgeApi.request_find_by_uf(choosen_state, 'female')

    json_both = JSON.parse(table_both.body)
    json_male = JSON.parse(table_male.body)
    json_female = JSON.parse(table_female.body)

    Layout.show_result_find_by_uf(
      choosen_state,
      json_both,
      json_male,
      json_female
    )
  end

  def self.find_by_city
    Layout.title(2)
    user_city = gets.chomp.upcase
    city = City.where(name: user_city)

    while city.empty?
      Layout.invalid_messages(2)
      user_city = gets.chomp.upcase
      Layout.jump_line
      city = City.where(name: user_city)
    end

    if city.size > 1
      Layout.several_cities_found(user_city)
      city.each { |c| print "#{c.initial} " }
      Layout.jump_line
      user_initial = gets.chomp.upcase

      until city.pluck(:initial).include?(user_initial)
        Layout.invalid_messages(21)
        city.each { |c| print "#{c.initial} " }
        Layout.jump_line
        user_initial = gets.chomp.upcase
      end

      city = City.where(name: user_city, initial: user_initial)
    end

    city = city.first

    table_both = IbgeApi.request_find_by_city(city, 'both')
    table_male = IbgeApi.request_find_by_city(city, 'male')
    table_female = IbgeApi.request_find_by_city(city, 'female')

    json_both = JSON.parse(table_both.body)
    json_male = JSON.parse(table_male.body)
    json_female = JSON.parse(table_female.body)

    Layout.show_result_find_by_city(city, json_both, json_male, json_female)
  end

  def self.find_by_name
    Layout.title(3)
    names = gets.chomp.downcase
    names = names.gsub(' ', '').gsub(',', '%7C')

    table = IbgeApi.request_find_by_name(names)
    json = JSON.parse(table.body)

    if json.empty?
      Layout.result_not_found
    else
      decade_keys = (json.map do |data|
        data['res'].map do |res|
          res['periodo']
        end
      end).flatten.uniq

      decade_hash = Hash[decade_keys.zip]

      decade_hash.each do |key, _value|
        decade_hash[key] = 0
      end

      final_hash = {}
      names_array = json.map { |name_data| name_data['nome'] }
      names_array.each do |name|
        final_hash[name] = decade_hash.clone
      end

      json.each do |name_data|
        name_data['res'].each do |data|
          final_hash[name_data['nome']][data['periodo']] = data['frequencia']
        end
      end

      Layout.show_result_find_by_name(json, decade_keys, final_hash)
    end
  end
end
