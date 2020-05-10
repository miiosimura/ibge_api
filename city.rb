class City < ActiveRecord::Base
  validates_presence_of :code, :name, :initial, :population
  validates_uniqueness_of :code
end