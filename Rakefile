require File.expand_path(File.dirname(__FILE__) + '/lib/users')

namespace :db do
  task :create_indexes do
    Mongoid.load!(File.join(File.dirname(__FILE__), 'config/mongoid.yml'))
    Users::User.create_indexes
  end
end
