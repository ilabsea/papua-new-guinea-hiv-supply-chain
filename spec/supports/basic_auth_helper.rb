module BasicAuthHelper
  def basic_auth user, pwd
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pwd)
  end  
end