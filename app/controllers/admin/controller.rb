module Admin
	class Controller < ::ApplicationController
		before_filter :load_profiler
		before_filter :authenticate_user!
		
		private
		  	def load_profiler
		  		#Rack::MiniProfiler.authorize_request # logic to run this code
		  	end

			def after_sign_out_path_for(resource_or_scope)
		    	admin_root_path
		    end
	end

end