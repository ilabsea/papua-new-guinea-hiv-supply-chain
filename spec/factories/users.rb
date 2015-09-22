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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  sequence :user_name do |n|
	    "user_name_#{n}"
  end

  sequence :email do |n|
    "email_#{n}@gmail.com"
  end

  sequence :phone_number do |n|
    "phone_number#{n}"
  end

  factory :user do
  	 user_name
  	 email
  	 phone_number
  	 site
     password { "123456" }
     display_name "XXX"
     role { User::ROLES[rand(User::ROLES.size-1)] }
  end

  factory :user_site, :class => User do
    user_name
     email
     phone_number
     site
     password { "123456" }
     display_name "Site"
     role  User::ROLES_SITE 
  end

  factory :user_admin, :class => User do
    user_name
     email
     phone_number
     password { "123456" }
     display_name "admin"
     role  User::ROLES_ADMIN
  end

  factory :user_data_entry, :class => User do
    user_name
     email
     phone_number
     password { "123456" }
     display_name "data"
     role  User::ROLES_DATA_ENTRY
  end

  factory :user_reviewer, :class => User do
    user_name
     email
     phone_number
     password { "123456" }
     display_name "reviewer"
     role  User::ROLES_REVIEWER
  end
end
