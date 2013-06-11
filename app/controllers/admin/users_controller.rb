module Admin
	class UsersController < Controller
		def index
		 	@users = User.paginate paginate_options
		end
	end
end
