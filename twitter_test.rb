
def client(user)
  @_client ||= Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV['TWITTER_API_KEY']
    config.consumer_secret     = ENV['TWITTER_SECRET_KEY']
    config.access_token        = user.oauth_token
    config.access_token_secret = user.oauth_secret
  end
end
