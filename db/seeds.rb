# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.find_or_create_by_user_name( :email => "admin@png.com", 
             :password => "123456",
             :user_name => "admin",
             :phone_number => "0975553553",
             :display_name => "MoH of PNG")