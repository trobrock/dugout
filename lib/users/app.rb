module Users
  class App < Sinatra::Base
    configure :development do
      require 'awesome_print'

      use ::OmniAuth::Builder do
        provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
      end
    end

    # Github oauth actions

    get '/auth/:name/callback' do
      auth = request.env['omniauth.auth']
      p auth
    end

    get '/login' do
      redirect '/auth/github'
    end
  end
end
