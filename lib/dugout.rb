$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'mongoid'
require 'omniauth'
require 'omniauth/strategies/github'
require 'octokit'

require 'dugout/models/user'
require 'dugout/app'

module Dugout
  ALLOWED_ORG = "outright"
end
