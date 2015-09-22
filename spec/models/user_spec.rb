# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  user_name              :string(255)      default(""), not null
#  phone_number           :string(255)      default(""), not null
#  display_name           :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  site_id                :integer
#  role                   :string(255)
#

require 'spec_helper'

describe User do
  describe "User with role site " do
    before(:each) do
      @user = FactoryGirl.build(:user)
    end

    it "should not require site when role is not site " do
        @user.role = User::ROLES_ADMIN
        @user.site = nil
        @user.save.should eq true
        @user.errors.full_messages.size.should eq 0
    end

    it "should have error when role is eq site and no site is set to user" do
       @user.role = User::ROLES_SITE
       @user.site = nil
       @user.save.should eq false
       @user.errors.full_messages[0].should eq "Site can't be blank"
    end

    it "should have no error when role is eq site and site is set to user" do
      site = FactoryGirl.build :site
      @user.role = User::ROLES_SITE
      @user.site = site
      @user.save.should eq true
    end
  end  

  describe "Change password" do
  	before(:each) do
  		@user = FactoryGirl.build(:user, :password => '123456')
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
