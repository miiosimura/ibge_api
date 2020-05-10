require 'active_record'
require './config/database_connection'
require './database_migrations'
require './seed'

namespace :db do
  task :migrate do
    CreateCityTable.migrate(:up)
    CreateStateTable.migrate(:up)
  end

  task :drop do
    CreateCityTable.migrate(:down)
    CreateStateTable.migrate(:down)
  end

  task :seed do
    Seed.run
  end
end