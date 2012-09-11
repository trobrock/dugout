$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'mongoid'
require 'omniauth'
require 'omniauth/strategies/github'

require 'users/app'

module Users

end
