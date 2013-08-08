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
