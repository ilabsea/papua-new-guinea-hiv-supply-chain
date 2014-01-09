def load_provinces
    Province.destroy_all
    print "Loading provinces to database\n"
    [
      [ 'PG-NCD' ,  'National Capital District' ],
      [ 'PG-CPM' ,  'Central province' ],
      [ 'PG-CPK' ,  'Chimbu province'],
      [ 'PG-EHG' ,  'Eastern Highlands province' ],
      [ 'PG-EBR' ,  'East New Britain province' ],
      [ 'PG-ESW' ,  'East Sepik province' ],
      [ 'PG-EPW' ,  'Enga province' ],
      [ 'PG-GPK' ,  'Gulf province' ],
      [ 'PG-MPM' ,  'Madang province' ],
      [ 'PG-MRL' ,  'Manus  province'],
      [ 'PG-MBA' ,  'Milne Bay province'],
      [ 'PG-MPL' ,  'Morobe province' ],
      [ 'PG-NIK' ,  'New Ireland province' ],
      [ 'PG-NPP' ,  'Northern province' ],
      [ 'PG-SAN' ,  'Sandaun [West Sepik] province' ],
      [ 'PG-SHM' ,  'Southern Highlands province' ],
      [ 'PG-WPD' ,  'Western  province' ],
      [ 'PG-WHM' ,  'Western Highlands province' ],
      [ 'PG-WBK' ,  'West New Britain province' ],
      [ 'PG-NSB' ,  'Bougainville autonomous region' ]
    ].each do |province|
       print("\r Loading  Code : #{province[0]}, Name : #{province[1]} ")
       Province.create!(:code => province[0], :name => province[1])
    end
    print "\n Done loading #{Province.count} provinces\n"
end

def load_sites
    ActiveRecord::Base.connection.execute("TRUNCATE sites") 
    print "Loading sites to database\n"
    [
      ['Begabari', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Buimo', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Epeanda', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Ereitave Uvi', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Good Samaritan', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Goroka Paedietrics', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Heduru', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Hillary Clinic (Pead)', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Himara Kigiro', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Id Inad-Madang', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Inauaia', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Innanaka', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Kudjib', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Lawes Road', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Leguava', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Lema Budoiya', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Lihir Private', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['MAC', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Mambisanda', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Migende', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Moro', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Mutzing', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Nina', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Odi', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Raihu', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Ramu', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Rebiamul', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Siroga', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['St Geralds', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Tabubil', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['Tininga', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['9 mile', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['AMDCC', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ["Veifa'a", '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ["Vunapope", '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ["Wasaie", '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ["WBC - PMGH", '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id],
      ['St Josephs', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", Province.find_by_code('PG-NCD').id]                          
    ].each do |site|
        print("\r Loading Site : #{site[0]}")
        Site.create!(:name => site[0],
                     :lat => site[1],
                     :lng => site[2],
                     :service_type => site[3],
                     :suggestion_order => site[4],
                     :order_frequency => 0.2 + site[5],
                     :number_of_deadline_sumission => 1+site[6],
                     :order_start_at => site[7],
                     :test_kit_waste_acceptable => site[8],
                     :address => site[9],
                     :contact_name => site[10],
                     :mobile => site[11],
                     :land_line_number => site[12],
                     :email => site[13],
                     :in_every => 1+rand(3),
                     :province_id => site[14])
    end
    print "\n Done loading #{Site.count} sites \n"
end

def load_categories
    ActiveRecord::Base.connection.execute("TRUNCATE categories") 
    print("\n Loading Category") 
    [ 
      ["Drugs", "HIV/AIDS Drugs"],
      ["Kits" , "HIV/AIDS Kids"]
      
    ].each do |category|
       Category.find_or_create_by_name(:name => category[0], :description => category[1] )
       print("\n loaded: #{category[0]} to database")
    end
    
    print("\n Done loading categories #{Category.count}\n")
end

def load_commodity_categories
  ActiveRecord::Base.connection.execute("TRUNCATE commodity_categories")
  print("\n Loading Commodity Category")
  [
    ["ARV Adult 1st Line", CommodityCategory::TYPES_DRUG ],
    ["ARV Adult 2nd Line", CommodityCategory::TYPES_DRUG ],
    ["ARV Pediatric 1st line", CommodityCategory::TYPES_DRUG ],
    ["ARV Pediatric 2nd line", CommodityCategory::TYPES_DRUG ],
    ["OI Drugs", CommodityCategory::TYPES_DRUG ],
    ["Kits", CommodityCategory::TYPES_DRUG ],
    ["HIV Test Kits and Bundles", CommodityCategory::TYPES_KIT ],
    ["BD FACSCount Reagents", CommodityCategory::TYPES_KIT ],
    ["PIMA CD4 Test Reagents/Consumables", CommodityCategory::TYPES_KIT ],
    ["EID Consumables", CommodityCategory::TYPES_KIT]
  ].each do |el|
      CommodityCategory.create!(:name => el[0], :com_type => el[1])
      print("\n loaded: #{el[0]} to database")
  end

  print("\n Done loading commodity category #{CommodityCategory.count}\n")
end

def load_units
  ActiveRecord::Base.connection.execute("TRUNCATE units")
  print("\n Loading Unit")
  [
    ["Bott"],
    ["Vials"],
    ["Pkt"],
    ["Cont"],
    ["Roll"],
    ["Box"]
  ].each do |el|
    Unit.find_or_create_by_name(:name => el[0])
    print("\n loaded: #{el[0]} to database")
  end

  print("\n Done loading unit #{Unit.count}\n")
end

def load_setting_messages
  print("\n Loading Setting Messages")
  [
    ["message_alerting_site_about_receiving_form", "Hi {site}, new package has been sent to you on {shipping_date}, consignment {consignment}. Please respond yes when you received the package."],
    ["message_asking_site", "Hi {site}, did you received package that was sent on {shipping_date}, {consigment} ? Please respond yes if you received."],
    ["message_deadline", "Hi {site}, you are late to submit requisition form. The deadline was on {dead_line}, please submit as soon as possible."],
    ["hour", 0]
  ].each do |el|
    Setting.find_or_create_by_name(:name => el[0], :value => el[1])
    print("\n loaded: #{el[0]} to database")
  end

  print("\n Done loading setting message #{Setting.count}\n")
end

def load_commodities
  ActiveRecord::Base.connection.execute("TRUNCATE commodities")
  print("\n Loading Commodities")


  commodities = [
                  ["Zidovudine + Lamividine + Nevirapine",  "300+150+200mg", "AZT/3TC/NVP", "60s"],
                  ["Zidovudine + Lamivudine",  "300+150mg", "AZT/3TC", "60s"],
                  ["Tenofovir + Lamivudine + Efavirenz",  "300+300+600mg", "TDF/3TC/EFV", "60s"],
                  ["Tenofovir + Lamivudine + Nevirapine",  "300+300+200mg", "TDF/3TC/NVP", "60s"],
                  ["Tenofovir + Lamivudine Tablet",  "300+300", "TDF/3TC", "60s"],
                  ["Efaviranz Tablets",  "600mg", "EFV", "30s"],
                  ["Lamivudine Tablet",  "150mg", "3TC", "60s"],
                  ["Zidovudine Tablets",  "300mg", "AZT", "60s"],
                  ["Zidovudine Capsules",  "100mg", "AZT", "60s"],
                  ["Nevirapine Tablets",  "200mg", "NVP", "60s"],
                  ["TDF",  "300mg", "TDF", "30s"],
                  ["D4T/3TC/NVP",  "300mg", "D4T/3TC/NVP", "30s"],
                  ["AZT/3TC/NVP",  "300mg", "AZT/3TC/NVP", "30s"],
                  ["D4T/3TC/EFV",  "300mg", "D4T/3TC/EFV", "30s"],
                  ["AZT/3TC/EFV",  "300mg", "AZT/3TC/EFV", "30s"],
                  ["NVP",  "300mg", "NVP", "30s"],
                  ["NVP/AZT",  "300mg", "NVP/AZT", "30s"],
                  ["TDF/3TC/EFV",  "300mg", "TDF/3TC/EFV", "30s"],
                  ["TDF/3TC/NVP",  "300mg", "TDF/3TC/NVP", "30s"],
                  ["TDF/ABC/LPVr",  "300mg", "TDF/ABC/LPVr", "30s"],
                  ["TDF/AZT/3TC/LPVr",  "300mg", "TDF/AZT/3TC/LPVr", "30s"],
                  ["ZDV/3TC/NVP",  "300mg", "ZDV/3TC/NVP", "30s"],
                  ["ZDV/3TC/EFV",  "300mg", "ZDV/3TC/EFV", "30s"],
                  ["TDF/NVP",  "300mg", "TDF/NVP", "30s"],
                  ["Septrin",  "300mg", "Septrin", "30s"],
                  ["Pep",  "300mg", "Pep", "30s"],
                  ["PMTCT",  "300mg", "PMTCT", "30s"],
                  ["Prophylaxis",  "300mg", "Prophylaxis", "30s"],
                  ["CTX",  "300mg", "CTX", "30s"],
                  ["Oth Comb",  "300mg", "Oth Comb", "30s"],
                  ["INH",  "300mg", "INH", "30s"],
                  ["1st Line to 2nd Line",  "300mg", "1st Line to 2nd Line", "30s"],
                  ["Others (2nd line)",  "300mg", "Others (2nd line)", "30s"],
                  ["Others",  "300mg", "Others", "30s"] ]

    category = CommodityCategory.find_by_name("ARV Adult 1st Line")
    unit = Unit.find_by_name("Bott")              
    commodities.each do |el|
       Commodity.create!( :name => el[0], 
                          :commodity_category_id => category.id, 
                          :unit_id => unit.id, 
                          :strength_dosage => el[1], 
                          :abbreviation => el[2], 
                          :quantity_per_packg => el[3],
                          :consumption_per_client_unit => 1+rand(100),
                          :consumption_per_client_pack => 1+rand(10),
                          :quantity_per_packg => rand(100))

       print("\n loaded: #{el[0]} to database")                   
    end





   commodities = [  ["Determine HIV 1/2 (100 test) with buffer",   nil, nil, nil],
                    ["Statpak HIV 1/2",   nil, nil],
                    ["Immunocomb HIV 1/2  (100 test)",   nil, nil],
                    ["Microplates (U plates)",   nil, nil, nil],
                    ["Serodia HIV 1/2 (55x4)",   nil, nil, nil],
                    ["DBS Bundles for HIV QA",   nil, nil, nil],
                    ["CD4 Reagents",   nil, nil, nil],
                    ["CD4 Controls",   nil, nil, nil],
                    ["FACS Sheath Fluid (OSMOSOL) (20Litres)",   nil, nil, nil],
                    ["FACS Clean",   nil, nil, nil],
                    ["BD FACS Rinse 5L",   nil, nil, nil],
                    ["BD FACSCount Thermal Paper",   nil, nil, nil],
                    ["Pipet tips (20ul-200ul)",   nil, nil, nil],
                    ["Purple tube (EDTA)",   nil, nil, nil],
                    ["PIMA Reagents",   nil, nil, nil],
                    ["PIMA Control Standard Beads",   nil, nil, nil],
                    ["PIMA Printer Paper Roll",   nil, nil, nil],
                    ["PIMA consumable bundles",   nil, nil, nil],
                    ["DBS Bundles for Early Iinfant Diagnosis testing",   nil, nil, nil]
                 ]
  category = CommodityCategory.find_by_name("HIV Test Kits and Bundles")
  unit =  Unit.find_by_name("Pkt")               
  commodities.each do |el|
    Commodity.create!(:name => el[0], 
                      :commodity_category_id => category.id, 
                      :unit_id => unit.id, 
                      :strength_dosage => el[1], 
                      :abbreviation => el[2], 
                      :quantity_per_packg => el[3],
                      :consumption_per_client_unit => rand(500) ,
                      :consumption_per_client_pack => 1+rand(10),
                      :quantity_per_packg => rand(500)   ) 
    print("\n loaded: #{el[0]} to database")
  end

  print("\n Done loading commodities #{Commodity.count}\n")
end

namespace :png do
  desc "Load PNG provinces to the database" 
  task :load_provinces => :environment do
      load_provinces
  end

  desc "Load PNG sites to the database"
  task :load_sites => :environment do
      load_sites
  end
  
  desc "Loading Drug category"
  task :load_categories => :environment do
    load_categories
  end

  desc "Loading Commodity Category"
  task  :load_commodity_categories => :environment do
      load_commodity_categories
  end

  desc "Loading Unit"
  task :load_unit => :environment do
     load_units
  end

  desc "Loading Commodities"
  task  :load_commodities => :environment do
     load_commodities
  end

  desc "Loading Setting Messages"
  task :load_setting_messages => :environment do
      load_setting_messages
  end

  def load_users
    [
      {:email => "site@png.com", :password => "123456", :user_name => "site", :phone_number => "097550",:display_name => "Site", :role => User::ROLES_SITE , :site_id => Site.first.id },
      {:email => "entry@png.com", :password => "123456", :user_name => "data", :phone_number => "097551",:display_name => "Data", :role => User::ROLES_DATA_ENTRY },
      {:email => "reviewer@png.com", :password => "123456", :user_name => "reviewer", :phone_number => "097552",:display_name => "Reviewer", :role => User::ROLES_REVIEWER },
      {:email => "ams@png.com", :password => "123456", :user_name => "ams", :phone_number => "097553",:display_name => "AMS", :role => User::ROLES_AMS }
    ].each do |options|
      User.create! options
      print("\n user #{options[:role]} :#{options[:user_name]} - #{options[:password]} ")
    end
    print("\n Done loading user")
  end


  desc "Loading PNG Default Data"
  task :load_default_data => :environment do
    load_provinces
    load_units
    load_categories
    load_commodity_categories
    load_commodities
    load_sites
    load_users
  end

end