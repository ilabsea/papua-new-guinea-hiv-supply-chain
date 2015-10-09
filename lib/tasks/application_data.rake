def load_lab_test_categories
  ['HIV Screening', 'HIV Confirmatory', 'CD4', 'Viral Load', 'EID'].each do |name|
    LabTestCategory.create!(name: name)
  end
end

def load_regimen_categories
  ['Adult', 'Children'].each do |name|
    RegimenCategory.create!(name: name)
  end
end

def load_lab_test
  lab_test_categories = LabTestCategory.all
  units          = Unit.all
  [
    ['Test1'],
    ['Test2'],
    ['Test3'],
    ['Test4']
  ].each do |el|
    LabTest.create!(name: el[0],
                   lab_test_category_id: lab_test_categories.shuffle.first.id,
                   unit_id: units.shuffle.first.id
                   )
  end
end

def load_regimen
  regimen_categories = RegimenCategory.all
  units              = Unit.all
  [
    ['Regimen1', '100mg'],
    ['Regimen2', '200mg'],
    ['Regimen3', '300mg'],
    ['Regimen4', '400mg'],
    ['Regimen5', '500mg']
  ].each do |el|
    Regimen.create!(name: el[0],
                   strength_dosage: el[1],
                   regimen_category_id: regimen_categories.shuffle.first.id,
                   unit_id: units.shuffle.first.id
      )
  end
end


def load_provinces
    ActiveRecord::Base.connection.execute("TRUNCATE sites")
    output_message "Loading provinces to database"
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
       output_message("Loading  Code : #{province[0]}, Name : #{province[1]} ")
       Province.create!(:code => province[0], :name => province[1])
    end
    output_message "Done loading #{Province.count} provinces"
end

def load_sites
    ActiveRecord::Base.connection.execute("TRUNCATE sites")
    provinces = Province.all
    output_message "Loading sites to database"
    [
      ['Begabari', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Buimo', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Epeanda', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Ereitave Uvi', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Good Samaritan', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Goroka Paedietrics', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Heduru', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Hillary Clinic (Pead)', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Himara Kigiro', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Id Inad-Madang', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Inauaia', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Innanaka', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Kudjib', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Lawes Road', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Leguava', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Lema Budoiya', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Lihir Private', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['MAC', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Mambisanda', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Migende', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Moro', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Mutzing', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Nina', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Odi', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Raihu', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Ramu', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Rebiamul', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Siroga', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['St Geralds', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Tabubil', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['Tininga', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['9 mile', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['AMDCC', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ["Veifa'a", '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ["Vunapope", '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ["Wasaie", '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ["WBC - PMGH", '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id],
      ['St Josephs', '', '', Site::SeviceType[0], 0, 0, 0, "2013-06-27", 0, "adress", "admin", "85512000000", "85512000000", "admin@instedd.org", provinces.shuffle.first.id]                          
    ].each do |site|
        output_message("Loading Site : #{site[0]}")
        Site.create!(:name => site[0],
                     :lat => site[1],
                     :lng => site[2],
                     :service_type => site[3],
                     :suggestion_order => site[4],
                     :order_frequency => 1 + rand(3) + site[5],
                     :number_of_deadline_sumission => 1+site[6],
                     :order_start_at => site[7],
                     :test_kit_waste_acceptable => rand(20),
                     :address => site[9],
                     :contact_name => site[10],
                     :mobile => site[11],
                     :land_line_number => site[12],
                     :email => site[13],
                     :in_every => 1+rand(3),
                     :province_id => site[14])
    end
    output_message "Done loading #{Site.count} sites"
end

def load_categories
    ActiveRecord::Base.connection.execute("TRUNCATE categories") 
    output_message("Loading Category") 
    [ 
      ["Drugs", "HIV/AIDS Drugs"],
      ["Kits" , "HIV/AIDS Kits"]
      
    ].each do |category|
       Category.find_or_create_by_name(:name => category[0], :description => category[1] )
       output_message("Loaded: #{category[0]} to database")
    end
    
    output_message("Done loading categories #{Category.count}")
end

def load_commodity_categories
  ActiveRecord::Base.connection.execute("TRUNCATE commodity_categories")
  output_message("Loading Commodity Category")
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
      output_message("Loaded: #{el[0]} to database")
  end

  output_message("Done loading commodity category #{CommodityCategory.count}")
end

def load_units
  ActiveRecord::Base.connection.execute("TRUNCATE units")
  output_message("Loading Unit")
  [
    ["Bott"],
    ["Vials"],
    ["Pkt"],
    ["Cont"],
    ["Roll"],
    ["Box"]
  ].each do |el|
    Unit.find_or_create_by_name(:name => el[0])
    output_message("Loaded: #{el[0]} to database")
  end

  output_message("Done loading unit #{Unit.count}")
end

def load_setting_messages
  print("\n Loading Setting Messages")
  [
    ["message_alerting_site_for_shipment", "Message notification of package deliver to site: {site} , consignment: {consignment}, shipment date: {shipment_date}, carton number: {carton_number} ."],
    ["message_asking_site", "Message check for confirmation of receiving package to site: {site}, consignment: {consignment}, shipment_date: {shipment_date} ."],
    ["message_deadline", "Message reminder to site who did not submit requisition form by deadline site: {site}, deadline date: {deadline_date}"],
    ["site_message_success", "Acknowledgment message: message has been sent to system successfully"],
    ["site_message_error_syntax", "message syntax error"],
    ["site_message_invalid_consignment_number", "consignment number is invalid"],
    ["site_message_invalid_status", "status is invalid"],
    ["site_message_invalid_carton_format", "invalid carton format"],
    ["site_message_invalid_sender", "phone number is not allowed to report"]
  ].each do |el|
    Setting.find_or_create_by_name(:name => el[0], :value => el[1])
    output_message("Loaded: #{el[0]} to database")
  end

  output_message("Done loading setting message #{Setting.count}")
end

def load_commodities
  ActiveRecord::Base.connection.execute("TRUNCATE commodities")
  output_message("Loading Commodities")


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

    commodity_categories = CommodityCategory.where(['com_type = ?', CommodityCategory::TYPES_DRUG])
    units = Unit.all
    regimens = Regimen.all
    lab_tests = LabTest.all

    commodities.each do |el|
      Commodity.create!( :name => el[0], 
                         :commodity_category_id => commodity_categories.shuffle.first.id, 
                         :unit_id => units.shuffle.first.id,
                         :strength_dosage => el[1],
                         :abbreviation => el[2],
                         :pack_size => 1 + rand(10),
                         :quantity_per_packg => el[3],
                         :regimen_id => regimens.shuffle.first.id 
                         )

      output_message("Loaded: #{el[0]} to database")
    end





   commodities = [  ["Determine HIV 1/2 (100 test) with buffer", "300+150+200mg", nil, "30s"],
                    ["Statpak HIV 1/2", "300+150mg", nil, "30s"],
                    ["Immunocomb HIV 1/2  (100 test)", "300+300+200mg", nil, "30s"],
                    ["Microplates (U plates)", "300+300+200mg", nil, "30s"],
                    ["Serodia HIV 1/2 (55x4)", "300+300+200mg", nil, "30s"],
                    ["DBS Bundles for HIV QA", "300+300+200mg", nil, "30s"],
                    ["CD4 Reagents", "300+300+200mg", nil, "30s"],
                    ["CD4 Controls", "300+300+200mg", nil, "30s"],
                    ["FACS Sheath Fluid (OSMOSOL) (20Litres)", "500mg",nil, "30s"],
                    ["FACS Clean", "300+300+200mg", nil, "30s"],
                    ["BD FACS Rinse 5L", "300+300+200mg", nil, "30s"],
                    ["BD FACSCount Thermal Paper", "300+300+200mg", nil, "30s"],
                    ["Pipet tips (20ul-200ul)", "300+300+200mg", nil, "30s"],
                    ["Purple tube (EDTA)", "300+300+200mg", nil, "30s"],
                    ["PIMA Reagents", "100mg", nil, "30s"],
                    ["PIMA Control Standard Beads", "300mg", nil, "30s"],
                    ["PIMA Printer Paper Roll", "500mg", nil, "30s"],
                    ["PIMA consumable bundles", "300mg", nil, "30s"],
                    ["DBS Bundles for Early Iinfant Diagnosis testing", "200mg", nil, "30s"]
                 ]

  commodity_categories = CommodityCategory.where(['com_type = ?', CommodityCategory::TYPES_KIT])
  commodities.each do |el|
    Commodity.create!(:name => el[0], 
                      :commodity_category_id => commodity_categories.shuffle.first.id, 
                      :unit_id => units.shuffle.first.id, 
                      :strength_dosage => el[1],
                      :abbreviation => el[2],
                      :pack_size => 1 + rand(10),
                      :quantity_per_packg => el[3],
                      :lab_test_id => lab_tests.shuffle.first.id
                      )
    output_message("Loaded: #{el[0]} to database")
  end

  output_message("Done loading commodities #{Commodity.count}")
end

def load_users
  [
    {:email => "admin@png.com", :password => "123456", :user_name => "admin", :phone_number => "097554",:display_name => "Admin", :role => User::ROLES_ADMIN },
    {:email => "site-beg@png.com", :password => "123456", :user_name => "site-beg", :phone_number => "097560",:display_name => "Site Beg", :role => User::ROLES_SITE , :site_id => Site.find_by_name("Begabari").id },
    {:email => "site-9mile@png.com", :password => "123456", :user_name => "site-9mile", :phone_number => "097570",:display_name => "Site 9 Mile", :role => User::ROLES_SITE , :site_id => Site.find_by_name("9 mile").id },
    {:email => "site-amd@png.com", :password => "123456", :user_name => "site-amd", :phone_number => "097580",:display_name => "Site AMDCC", :role => User::ROLES_SITE , :site_id => Site.find_by_name("AMDCC").id },
    {:email => "data@png.com", :password => "123456", :user_name => "data", :phone_number => "097551",:display_name => "Data", :role => User::ROLES_DATA_ENTRY },
    {:email => "data-reviewer@png.com", :password => "123456", :user_name => "data-reviewer", :phone_number => "097852",:display_name => "Date Entry Reviewer", :role => User::ROLES_DATA_ENTRY_AND_REVIEWER },
    {:email => "reviewer@png.com", :password => "123456", :user_name => "reviewer", :phone_number => "097552",:display_name => "Reviewer", :role => User::ROLES_REVIEWER },
    {:email => "ams@png.com", :password => "123456", :user_name => "ams", :phone_number => "097553",:display_name => "AMS", :role => User::ROLES_AMS }
  ].each do |options|
    User.create! options
    output_message("User #{options[:role]} :#{options[:user_name]} - #{options[:password]} ")
  end
  output_message("Done loading user")
end

def output_message(message)
  print("\r #{message}")
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


  desc "Loading PNG Default Data"
  task :load_default_data => :environment do
    abort("Not allow to run this on production server") if Rails.env.production?

    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke

    ActiveRecord::Base.transaction do
      load_setting_messages
      load_provinces
      load_sites
      load_users

      load_units

      load_regimen_categories
      load_lab_test_categories
      load_regimen
      load_lab_test

      load_categories
      load_commodity_categories
      load_commodities
    end
  end

end