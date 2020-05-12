class IbgeApi
  BASE_URI = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes'

  def self.request_find_by_uf(choosen_state, gender)
    if gender == 'both'
      Faraday.get("#{BASE_URI}/ranking?localidade=#{choosen_state.code}")
    elsif gender == 'male'
      Faraday.get("#{BASE_URI}/ranking?localidade=#{choosen_state.code}&sexo=M")
    elsif gender == 'female'
      Faraday.get("#{BASE_URI}/ranking?localidade=#{choosen_state.code}&sexo=F")
    end
  end

  def self.request_find_by_city(city, gender)
    if gender == 'both'
      Faraday.get("#{BASE_URI}/ranking?localidade=#{city.code}")
    elsif gender == 'male'
      Faraday.get("#{BASE_URI}/ranking?localidade=#{city.code}&sexo=M")
    elsif gender == 'female'
      Faraday.get("#{BASE_URI}/ranking?localidade=#{city.code}&sexo=F")
    end
  end

  def self.request_find_by_name(names)
    Faraday.get("#{BASE_URI}/#{names}")
  end
end