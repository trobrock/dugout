module Users
  class App < Sinatra::Base
    configure do
      use ::OmniAuth::Builder do
        provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
      end
    end

    configure :production do
      Mongoid.load! File.expand_path(File.dirname(__FILE__) + '../../../config/mongoid.yml'), :production
    end

    configure :development do
      Mongoid.load! File.expand_path(File.dirname(__FILE__) + '../../../config/mongoid.yml'), :development
    end

    before do
      session['postback'] = params['postback'] if params['postback']
      if current_user && session['postback']
        page = session['postback']
        session.delete('postback')
        redirect "#{page}?token=#{current_user._id}"
      elsif !current_user && !login_path?(request.path_info)
        redirect '/login'
      end
    end

    # Github oauth actions

    get '/auth/:name/callback' do
      auth            = request.env['omniauth.auth']
      github_username = auth['extra']['raw_info']['login']
      oauth_token     = auth['credentials']['token']

      user = User.from_oauth(github_username, oauth_token)
      return 403 unless user.has_permission?
      user.save!

      session['token'] = user._id
      redirect '/'
    end

    get '/login' do
      redirect '/auth/github'
    end

    error 403 do
      'Access forbidden'
    end

    # API

    get '/' do
      User.all.to_json
    end

    get '/myself' do
      current_user.to_json
    end

    get '/:login' do
      User.where(login: params[:login]).first.to_json
    end

    private

    def current_user
      token = params['token'] || session['token']
      token && User.where(:_id => token).first
    end

    def login_path?(path)
      path =~ /\/login/ ||
        path =~ /\/auth/  ||
        path =~ /\/online/||
        path =~ /\/api/
    end
  end
end
