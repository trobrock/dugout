require File.expand_path(File.dirname(__FILE__) + '/lib/dugout')

use Rack::Session::Cookie

run Dugout::App.new
