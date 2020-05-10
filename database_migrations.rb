class CreateCityTable < ActiveRecord::Migration[5.2]
  def up
    unless ActiveRecord::Base.connection.table_exists?(:cities)
      create_table :cities do |table|
        table.integer :code
        table.string :name
        table.string :initial
        table.integer :population
      end
    end
  end

  def down
    if ActiveRecord::Base.connection.table_exists?(:cities)
      drop_table :cities
    end
  end
end

class CreateStateTable < ActiveRecord::Migration[5.2]
  def up
    unless ActiveRecord::Base.connection.table_exists?(:states)
      create_table :states do |table|
        table.string :initial
        table.integer :code
        table.string :name
        table.integer :population
      end
    end
  end

  def down
    if ActiveRecord::Base.connection.table_exists?(:states)
      drop_table :states
    end
  end
end