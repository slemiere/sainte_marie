require 'sinatra/base'
require 'redis'

class Server < Sinatra::Base
  redis = Redis.new(
    url: ENV['REDIS_URL'] || 'redis://localhost:6379',
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  )
  get "/add" do
    redis.incr("key")
    return "OK"
  end
  get '/read' do
    redis.get("key")
  end

  post '/message' do
    return "<?xml version="1.0" encoding="UTF-8"?>
<Response>
    <Message>Votre vote pour les incroyables parents de Sainte Marie a été pris en compte! Merci et bonne soirée</Message>
</Response>"
end
