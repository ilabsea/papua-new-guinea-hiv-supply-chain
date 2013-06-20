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
     role { User::ROLES[rand(User::ROLES.size-1)] }
  end
end
