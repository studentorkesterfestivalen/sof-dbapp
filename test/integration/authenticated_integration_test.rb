class AuthenticatedIntegrationTest < ActionDispatch::IntegrationTest
  def current_user
    if @user.nil?
      @user = User.new
      @user.email = 'test@sof17.se'
      @user.password = 'hunter2760'
      @user.skip_confirmation!
      @user.save!
    end

    @user
  end

  def auth_headers
    if @auth_token.nil?
      @auth_token = current_user.create_new_auth_token
    end

    @auth_token
  end

  def redirected_url
    @response.headers['location']
  end
end