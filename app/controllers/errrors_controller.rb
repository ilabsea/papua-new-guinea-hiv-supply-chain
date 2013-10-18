class ErrorsController < ActionController::Base
  layout 'error'

  def unauthorized_401
    @error =  { code: 401, text: 'Unauthorized.' }

  end
 
  def not_found_404
    @error = { code: 404, text: 'Page not found. Please verify your url again.'}
  end
 
  def error_500
    @error = { code: 500, text: 'Internal server error.' }
  end
 
 
  # The exception that resulted in this error action being called can be accessed from
  # the env. From there you can get a backtrace and/or message or whatever else is stored
  # in the exception object.
  def the_exception
    @e ||= env["action_dispatch.exception"]
  end

  helper_method :the_exception
end