require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'slim/include'
Dir.glob('./models/*'){|file| require file}
Dir.glob('./error/*'){|file| require file}
Dir.glob('./logic/*'){|file| require file}

enable :sessions

#####################################
# フィルタ
before do
  # ログイン確認しないパス
  exclude_paths = []
  exclude_paths << '/'
  exclude_paths << '/login'
  exclude_paths << '/add_user'

  unless exclude_paths.include?(request.path_info) || exclude_paths.include?(request['path'])
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
  logic = Login.new(request)
  if logic.login?
    session[:loggedin] = true
    slim :index
  else
    @messages = ['ログインできません。名前またはパスワードが間違っています。']
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
  logic = AddUser.new(request)
  @messages = logic.validate
  if @messages.empty?
    logic.add_user

    @messages = ["ユーザ：#{request['name']}を登録しました。"]
    @path = '/login'
    slim :result
  else
    slim :add_user
  end
end

post '/route' do
  template = request['path'].to_sym
  slim template
end

#####################################
# 例外処理
#####################################

error SessionError do
  @messages = ['ログインしてください']
  slim :login
end
