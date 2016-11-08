require 'sinatra'
require 'sinatra/reloader'
require 'slim'
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
  slim :login
end

post '/login' do
  if User.exists?(name: request['name'], password: request['password'])
      session[:loggedin] = true
      slim :index
  else
      slim :login
  end
end

# menu
get '/index' do
  if session[:loggedin]
      slim :index
  else
      slim :login
  end
end

# Users
get '/add_user' do
  slim :add_user
end

post '/add_user' do
  u = User.new
  u.name = request['name']
  u.password = request['password']
  u.mail = request['mail']

  u.save!

  slim :login
end

#####################################
# 例外処理
#####################################

error SessionError do
  @messages = ['ログインしてください']
  slim :login
end
