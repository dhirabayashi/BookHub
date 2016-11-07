require 'sinatra'
require 'sinatra/reloader'
require './models/user.rb'
require './error/session_error.rb'

enable :sessions

#####################################
# フィルタ
#####################################

before do
    # ログイン確認しないパス
    exclude_paths = []
    exclude_paths << '/'
    exclude_paths << '/login'
    exclude_paths << '/add_user'
    
    unless exclude_paths.include?(request.path_info)
        # ログイン確認
        unless session[:loggedin]
            raise SessionError
        end
    end
end

#####################################
# ルーティング
#####################################

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

#####################################
# 例外処理
#####################################

error SessionError do
    @messages = ['ログインしてください']
    erb :login
end
