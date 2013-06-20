# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!( :email => "admin@png.com", 
             :password => "123456",
             :user_name => "admin",
             :phone_number => "0975553553",
             :display_name => "MoH of PNG",
             :site_id => Site.first.id
             )
p "create user: #{admin} pwd: 123456"