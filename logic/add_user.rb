class AddUser
  def initialize(request)
    @request = request
  end

  def validate
    name = @request['name']
    password = @request['password']
    confirm = @request['confirm']

    messages = []

    if name.empty?
      messages << '名前を入力してください。'
    end
    if password.empty?
      messages << 'パスワードを入力してください。'
    end
    if confirm.empty?
      messages << 'パスワード確認を入力してください。'
    end

    unless password == confirm
      messages << 'パスワードとパスワード確認が一致しません。'
    end
    if User.exists?(name: name)
      messages << "#{name}は登録済のため、使用できません。"
    end

    messages
  end

  def add_user
    u = User.new
    u.name = @request['name']
    u.password = @request['password']
    u.mail = @request['mail']

    u.save
  end
end
