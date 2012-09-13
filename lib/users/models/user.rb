module Users
  class User
    include Mongoid::Document

    field :login, type: String
    field :oauth_token, type: String

    index({ login: 1 }, { unique: true })

    def self.from_oauth(login, oauth_token)
      p login
      p oauth_token
      p self.where(login: login)
      found = self.where(login: login).first
      if found
        found.oauth_token = oauth_token
      else
        found = self.new(login: login, oauth_token: oauth_token)
      end
      found
    end

    def has_permission?
      client.organizations.map(&:login).include? ALLOWED_ORG
    end

    def client
      @client ||= Octokit::Client.new login: login, oauth_token: oauth_token
    end
  end
end
