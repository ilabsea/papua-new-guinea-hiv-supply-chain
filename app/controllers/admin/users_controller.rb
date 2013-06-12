module Admin
	class UsersController < Controller
		def index
		 	@users = User.includes(:site).paginate paginate_options
		end

		def new
			@user = User.new
		end

		def create
		   @user = User.new(params[:user])
		   if(@user.save)
		   	  redirect_to admin_user_path(@user), :notice => "User was successfully created"
		   else
		   	  render :new
		   end
		end

		def edit
		   @user = User.find(params[:id])
		end

		def show
		   @user = User.find(params[:id])
		end

		def update
			@user = User.find(params[:id])
			if(@user.update_attributes(params[:user]))
				redirect_to admin_user_path(@user), :notice => "User was successfully updated"
			else
				render :edit	
			end
		end

		def destroy	
			begin
				@user = User.find(params[:id])
			    @user.destroy
				redirect_to admin_users_path, :notice => "User was removed successfully"
			rescue
				redirect_to admin_users_path, :error => "Failed to removed user"
			end	
		end

		def reset
		  @user = User.find(params[:id])
		end

		def change
		  @user = User.find(params[:id])
		  
		  if @user.change_password? params[:user]
		  	redirect_to admin_users_path, :notice => "User password has been reset"
		  else
		  	render  :reset
		  end

		end



	end
end
