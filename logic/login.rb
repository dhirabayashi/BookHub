class Login
  def initialize(request)
    @request = request
  end

  def login?
    User.exists?(name: @request['name'], password: @request['password'])
  end
end
