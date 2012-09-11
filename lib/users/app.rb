module Users
  class App < Sinatra::Base
    configure do
      use ::OmniAuth::Builder do
        provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
      end
    end

    configure :development do
      Mongoid.load! File.expand_path(File.dirname(__FILE__) + '../../../config/mongoid.yml')
    end

    before do
      redirect '/login' unless current_user || login_path?(request.path_info)
    end

    get '/' do
      User.all.to_json
    end

    get '/:login' do
      User.where(login: params[:login]).first.to_json
    end

    # Github oauth actions

    get '/auth/:name/callback' do
      auth            = request.env['omniauth.auth']
      github_username = auth['extra']['raw_info']['login']
      oauth_token     = auth['credentials']['token']

      user = User.from_oauth(github_username, oauth_token)
      return 403 unless user.has_permission?
      user.save!

      session['user_id'] = user._id
      redirect '/'
    end

    get '/login' do
      redirect '/auth/github'
    end

    error 403 do
      'Access forbidden'
    end

    private

    def current_user
      session['user_id'] && User.where(:_id => session['user_id']).first
    end

    def login_path?(path)
      path =~ /\/login/ ||
        path =~ /\/auth/  ||
        path =~ /\/online/||
        path =~ /\/api/
    end
  end
end
