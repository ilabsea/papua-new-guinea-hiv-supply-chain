require 'spec_helper'

describe User do

  it "should require user_name to be unique" do
  	@user = FactoryGirl.build(:user)
  end
  

  describe "Change password" do
  	before(:each) do
  		@user = FactoryGirl.create(:user, :password => '123456')
  	end
  	it "should not change password when not valid" do 
  		options = { :current_password => '12345x',
  				    :password => "new_password" ,
  				  	:password_confirmation => "new_password"
  				  }
  	    change = @user.change_password? options
  	    change.should eq false
  	    @user.errors.full_messages.size.should eq(1)
  	    @user.errors.full_messages[0].should eq "Current password is not correct"
  	end

  	it "should change password when current_password is valid" do
  		options = { :current_password => '123456',
  				    :password => "new_password" ,
  				  	:password_confirmation => "new_password"
  				  }
  	    @user.change_password?(options).should eq true
  	    @user.valid_password?(options[:password])

  	end
  end

end
