def load_provinces
    Province.destroy_all
    print "Loading provinces to database\n"
    [
      [ 'PG-NCD' ,  'National Capital District' ],
      [ 'PG-CPM',   'Central province' ],
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
       Province.create!(:name => province[0], :code => province[1])
    end
    print "\n Done loading #{Province.count} provinces\n"
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
    ["ARV Adult 1st Line", CommodityCategory::TYPES[0][1]],
    ["ARV Adult 2nd Line", CommodityCategory::TYPES[0][1]],
    ["ARV Pediatric 1st line", CommodityCategory::TYPES[0][1]],
    ["ARV Pediatric 2nd line", CommodityCategory::TYPES[0][1]],
    ["OI Drugs", CommodityCategory::TYPES[0][1]],
    ["Kits", CommodityCategory::TYPES[0][1]],
    ["HIV Test Kits and Bundles", CommodityCategory::TYPES[1][1]],
    ["BD FACSCount Reagents", CommodityCategory::TYPES[1][1]],
    ["PIMA CD4 Test Reagents/Consumables", CommodityCategory::TYPES[1][1]],
    ["EID Consumables", CommodityCategory::TYPES[1][1]]
  ].each do |el|
      CommodityCategory.find_or_create_by_name(:name => el[0], :com_type => el[1])
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

def load_setting_message
  print("\n Loading Setting Message")
  [
    ["message_alerting_site_about_receiving_form", "Hi {site}, new package has been sent to you on {shipping_date}, consignment {consignment}. Please respond yes when you received the package."],
    ["message_asking_site", "Hi {site}, did you received package that was sent on {shipping_date}, {consigment} ? Please respond yes if you received."],
    ["message_deadline", "Hi {site}, you are late to submit requisition form. The deadline was on {dead_line}, please submit as soon as possible."]
  ].each do |el|
    Setting.find_or_create_by_name(:name => el[0], :value => el[1])
    print("\n loaded: #{el[0]} to database")
  end

  print("\n Done loading setting message #{Setting.count}\n")
end

def load_commodities
  print("\n Loading Commodities")
  [
    ["Zidovudine + Lamividine + Nevirapine", CommodityCategory.find_by_name("ARV Adult 1st Line").id, Unit.find_by_name("Bott").id, "300+150+200mg", "AZT + 3TC + NVP", "60s"],
    ["Zidovudine + Lamivudine", CommodityCategory.find_by_name("ARV Adult 1st Line").id, Unit.find_by_name("Bott").id, "300+150mg", "AZT + 3TC", "60s"],
    ["Tenofovir + Lamivudine + Efavirenz", CommodityCategory.find_by_name("ARV Adult 1st Line").id, Unit.find_by_name("Bott").id, "300+300+600mg", "TDF + 3TC + EFV", "60s"],
    ["Tenofovir + Lamivudine + Nevirapine", CommodityCategory.find_by_name("ARV Adult 1st Line").id, Unit.find_by_name("Bott").id, "300+300+200mg", "TDF + 3TC + NVP", "60s"],
    ["Tenofovir + Lamivudine Tablet", CommodityCategory.find_by_name("ARV Adult 1st Line").id, Unit.find_by_name("Bott").id, "300+300", "TDF+3TC", "60s"],
    ["Efaviranz Tablets", CommodityCategory.find_by_name("ARV Adult 1st Line").id, Unit.find_by_name("Bott").id, "600mg", "EFV", "30s"],
    ["Lamivudine Tablet", CommodityCategory.find_by_name("ARV Adult 1st Line").id, Unit.find_by_name("Bott").id, "150mg", "3TC", "60s"],
    ["Zidovudine Tablets", CommodityCategory.find_by_name("ARV Adult 1st Line").id, Unit.find_by_name("Bott").id, "300mg", "AZT", "60s"],
    ["Zidovudine Capsules", CommodityCategory.find_by_name("ARV Adult 1st Line").id, Unit.find_by_name("Bott").id, "100mg", "AZT", "60s"],
    ["Nevirapine Tablets", CommodityCategory.find_by_name("ARV Adult 1st Line").id, Unit.find_by_name("Bott").id, "200mg", "NVP", "60s"],
    ["Tenofovir Tablets", CommodityCategory.find_by_name("ARV Adult 1st Line").id, Unit.find_by_name("Bott").id, "300mg", "TDF", "30s"],
    ["Determine HIV 1/2 (100 test) with buffer", CommodityCategory.find_by_name("HIV Test Kits and Bundles").id, Unit.find_by_name("Pkt").id, nil, nil, nil],
    ["Statpak HIV 1/2", CommodityCategory.find_by_name("HIV Test Kits and Bundles").id, Unit.find_by_name("Pkt").id, nil, nil],
    ["Immunocomb HIV 1/2  (100 test)", CommodityCategory.find_by_name("HIV Test Kits and Bundles").id, Unit.find_by_name("Pkt").id, nil, nil],
    ["Microplates (U plates)", CommodityCategory.find_by_name("HIV Test Kits and Bundles").id, Unit.find_by_name("Pkt").id, nil, nil, nil],
    ["Serodia HIV 1/2 (55x4)", CommodityCategory.find_by_name("HIV Test Kits and Bundles").id, Unit.find_by_name("Pkt").id, nil, nil, nil]

  ].each do |el|
    Commodity.find_or_create_by_name(:name => el[0], :commodity_category_id => el[1], :unit_id => el[2], :strength_dosage => el[3], :abbreviation => el[4], :quantity_per_packg => el[5])
    print("\n loaded: #{el[0]} to database")
  end

  print("\n Done loading commodities #{Commodity.count}\n")
end

namespace :png do
  desc "Load PNG provinces to the database" 
  task :load_provinces => :environment do
      load_provinces
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

  desc "Loading Setting Message"
  task :load_setting_message => :environment do
      load_setting_message
  end

  desc "Loading PNG Default Data"
  task :load_default_data => :environment do
    load_provinces
    load_units
    load_categories
    load_commodity_categories
    load_commodities
  end

end