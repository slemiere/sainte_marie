require 'sinatra/base'

class Server < Sinatra::Base
  get "/" do
    "hello world"
  end
  get '/frank-says' do
    'Put this in your pipe & smoke it!'
  end
end
