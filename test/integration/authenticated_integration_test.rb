class AuthenticatedIntegrationTest < ActionDispatch::IntegrationTest
  def initialize(*args)
    super *args

    @auth_tokens = {}
  end

  def current_user
    @user ||= create_user 'test@sof17.se'
  end

  def create_user(email)
    user = User.new
    user.email = email
    user.password = 'hunter2760'
    user.skip_confirmation!
    user.save!

    user
  end

  def auth_headers(user=nil)
    user = user || current_user

    @auth_tokens[user] ||= user.create_new_auth_token
  end

  def redirected_url
    response.headers['location']
  end
end
