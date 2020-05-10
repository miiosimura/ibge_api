require 'active_record'
require './config/database_connection'
require 'csv'
require './city'
require './state'
require 'pry'

module Seed
  def self.run
    csv_states = File.read('states.csv')
    states = CSV.parse(csv_states, :headers => true)
    states.each do |row|
      State.create!(row.to_hash)
    end

    cities = CSV.read('cities.csv')
    cities.each do |code, name, initial, population|
      City.create(code: code, name: name.upcase, initial: initial, population: population)
    end
  end
end