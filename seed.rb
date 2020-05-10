require 'active_record'
require 'csv'
require './city'
require './state'
require 'pry'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'ibge.db'
)

csv_states = File.read('states.csv')
states = CSV.parse(csv_states, :headers => true)
states.each do |row|
  State.create!(row.to_hash)
end

csv_cities = File.read('cities.csv')
cities = CSV.parse(csv_cities, :headers => true)
cities.each do |row|
  City.create(row.to_hash)
end