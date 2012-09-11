$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'mongoid'
require 'omniauth'
require 'omniauth/strategies/github'
require 'octokit'

require 'users/models/user'
require 'users/app'

module Users
  ALLOWED_ORG = "outright"
end
