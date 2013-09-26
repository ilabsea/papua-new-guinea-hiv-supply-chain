module BasicAuthHelper
  def basic_auth user, pwd
  	# nuntium_config = NuntiumMessagingAdapter.instance.config
  	# user = nuntium_config[:incoming_username]
    # pwd  = nuntium_config[:incoming_password]
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pwd)
  end	
end