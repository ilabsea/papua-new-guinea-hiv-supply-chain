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

CommodityCategory.find_or_create_by_name(
  :name => "ARV Adult 1st Line",
  :com_type => CommodityCategory::TYPES[0][1])

CommodityCategory.find_or_create_by_name(
	:name => "ARV Adult 2nd Line",
	:com_type => CommodityCategory::TYPES[0][1])

CommodityCategory.find_or_create_by_name(
	:name => "ARV Pediatric 1st line",
	:com_type => CommodityCategory::TYPES[0][1])

CommodityCategory.find_or_create_by_name(
	:name => "ARV Pediatric 2nd line",
	:com_type => CommodityCategory::TYPES[0][1])

CommodityCategory.find_or_create_by_name(
	:name => "OI Drugs",
	:com_type => CommodityCategory::TYPES[0][1])

CommodityCategory.find_or_create_by_name(
	:name => "Kits",
	:com_type => CommodityCategory::TYPES[0][1])

CommodityCategory.find_or_create_by_name(
	:name => "HIV Test Kits and Bundles",
	:com_type => CommodityCategory::TYPES[1][1])

CommodityCategory.find_or_create_by_name(
	:name => "BD FACSCount Reagents",
	:com_type => CommodityCategory::TYPES[1][1])

CommodityCategory.find_or_create_by_name(
	:name => "PIMA CD4 Test Reagents/Consumables",
	:com_type => CommodityCategory::TYPES[1][1])

CommodityCategory.find_or_create_by_name(
	:name => "EID Consumables",
	:com_type => CommodityCategory::TYPES[1][1])


#Seed unit data

Unit.find_or_create_by_name(
	:name => "Bolt"
)

Unit.find_or_create_by_name(
	:name => "Vials"
)

Unit.find_or_create_by_name(
	:name => "Pkt"
)

Unit.find_or_create_by_name(
	:name => "Cont"
)

Unit.find_or_create_by_name(
	:name => "Roll"
)

Unit.find_or_create_by_name(
	:name => "Box"
)

