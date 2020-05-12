require 'faraday'
require 'json'
require 'pry'
require './config/database_connection'
require './city'
require './state'
require './interface'
require 'bundler/setup'

Interface.start