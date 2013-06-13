module Admin
	class Controller < ::ApplicationController
		before_filter :load_profiler

		private
		  def load_profiler
		  	Rack::MiniProfiler.authorize_request # logic to run this code
		  end
	end

end