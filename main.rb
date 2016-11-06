require 'sinatra'
require 'sinatra/reloader'
require './models/user.rb'

enable :sessions

get '/' do
    erb :login
end

post '/login' do
    if User.exists?(name: request['name'], password: request['password'])
        session[:loggedin] = true
        erb :index
    else
        erb :login
    end
end

# menu
get '/index' do
    if session[:loggedin]
        erb :index
    else
        erb :login
    end
end

# Users
get '/add_user' do
    erb :add_user
end

post '/add_user' do
    u = User.new
    u.name = request['name']
    u.password = request['password']
    u.mail = request['mail']

    u.save!

    erb :login
end
