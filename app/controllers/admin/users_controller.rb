module Admin
  class UsersController < Controller
    load_and_authorize_resource
    skip_load_resource :only => [:new_password]
    skip_authorize_resource :only =>[:new_password, :change, :profile, :update_profile]

    def index
       @users = User.order('role').includes(:site).paginate paginate_options
       @app_title = "Users"
    end

    def new
      @user = User.new
      @app_title = "New User"
    end

    def create
       @user = User.new(params[:user])
       if(@user.save)
           redirect_to admin_users_path, :notice => "User has been created successfully"
       else
           render :new
       end
    end

    def edit
       @user = User.find(params[:id])
       @app_title = "Edit user: #{@user.user_name}"
    end

    def update
      @user = User.find(params[:id])
      if(@user.update_attributes(params[:user]))
        redirect_to admin_users_path, :notice => "User has been updated successfully"
      else
        render :edit  
      end
    end

    def destroy  
      begin
        @user = User.find(params[:id])
          @user.destroy
        redirect_to admin_users_path, :notice => "User has been removed"
      rescue Exception => e
        redirect_to admin_users_path, :error => e.message
      end  
    end

    def new_password
      @app_title = 'Change Password'
    end

    def change
      if(current_user.change_password? params[:user])
        sign_in(current_user, :bypass => true)
        redirect_to new_password_admin_users_path, :notice => 'Your password has been reset successfully'
      else  
        render :new_password
      end
    end

    def profile
      @app_title = 'Update Profile'
    end

    def update_profile
       attributes = params[:user].slice(:phone_number, :display_name, :email)
       if current_user.update_attributes attributes
         redirect_to profile_admin_users_path, :notice => 'Your profile has been updated successfully'
       else
         render :profile      
       end
    end

    def reset
      @user = User.find(params[:id])
      @changed_password = @user.reset_random_password!

      @app_title = "Password reset"

      if !@changed_password
        redirect_to edit_admin_user_path(@user), :error => "Failed to reset password for this user. Please try again"
      end
    end
  end
end
