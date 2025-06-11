require 'sinatra/base'
require 'redis'

class Server < Sinatra::Base
  redis = Redis.new(
    url: ENV['REDIS_URL'] || 'redis://localhost:6379',
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  )
  get "/add" do
    redis.incr("key")
  end
  get '/read' do
    redis.get("key")
  end
end
