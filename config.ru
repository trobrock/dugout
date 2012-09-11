require File.expand_path(File.dirname(__FILE__) + '/lib/users')

use Rack::Session::Cookie

run Users::App.new
