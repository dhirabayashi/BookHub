require 'sinatra'
require 'sinatra/reloader'

get '/' do
    erb :login
end

post '/login' do
    "id=#{request['id']}, password=#{request['password']}"
end