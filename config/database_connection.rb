require 'active_record'
require './database_migrations'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'ibge.db'
)