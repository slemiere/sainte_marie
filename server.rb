require 'sinatra/base'
require 'redis'

class Server < Sinatra::Base
  redis = Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379'})
  get "/add" do
    redis.increment("key")
  end
  get '/read' do
    redis.get("key")
  end
end
