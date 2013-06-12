module Admin
	class UsersController < Controller
		def index
		 	@users = User.includes(:site).paginate paginate_options
		 	@app_title = "Users"
		end

		def new
			@user = User.new
			@app_title = "New User"
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
		   @app_title = "Edit user: #{@user.user_name}"
		end

		def show
		   @user = User.find(params[:id])
		   @app_title = "Detail: #{@user.user_name}"
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
			rescue Exception => e
				redirect_to admin_users_path, :error => e.message
			end	
		end

		def reset
		  @user = User.find(params[:id])
		  @app_title = "Reset password"
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
