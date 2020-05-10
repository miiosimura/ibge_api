require 'active_record'
require './database_migrations'
require './city'
require './state'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'ibge.db'
)

CreateCityTable.migrate(:up)
CreateStateTable.migrate(:up)