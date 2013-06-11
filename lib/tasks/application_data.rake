namespace :png do
  desc "Load PNG provinces to the database" 
  task :load_provinces => :environment do
      Province.destroy_all
      print "Loading provinces to database\n"
      [
        [ 'PG-NCD' , 	'National Capital District' ],
        [ 'PG-CPM',  	'Central province' ],
        [ 'PG-CPK' , 	'Chimbu province'],
        [ 'PG-EHG' , 	'Eastern Highlands province' ],
        [ 'PG-EBR' , 	'East New Britain province' ],
        [ 'PG-ESW' ,  'East Sepik province' ],
        [ 'PG-EPW' , 	'Enga province' ],
        [ 'PG-GPK' , 	'Gulf province' ],
        [ 'PG-MPM' , 	'Madang province' ],
        [ 'PG-MRL' , 	'Manus 	province'],
        [ 'PG-MBA' , 	'Milne Bay province'],
        [ 'PG-MPL' , 	'Morobe province' ],
        [ 'PG-NIK' , 	'New Ireland province' ],
        [ 'PG-NPP' , 	'Northern province' ],
        [ 'PG-SAN' , 	'Sandaun [West Sepik] province' ],
        [ 'PG-SHM' , 	'Southern Highlands province' ],
        [ 'PG-WPD' , 	'Western 	province' ],
        [ 'PG-WHM' , 	'Western Highlands province' ],
        [ 'PG-WBK' , 	'West New Britain province' ],
        [ 'PG-NSB' , 	'Bougainville autonomous region' ]
      ].each do |province|
         print("\r Loading  Code : #{province[0]}, Name : #{province[1]} ")
         Province.create!(:name => province[0], :code => province[1])
      end
      print "\n Done loading #{Province.count} provinces\n"
  end
  
  desc "Loading Drug category"
  
  task :load_categories => :environment do 
    Category.destroy_all
    print("\n Loading Category") 
    [ 
      ["Drugs", "HIV/AIDS Drugs"],
      ["Kids" , "HIV/AIDS Kids"]
      
    ].each do |category|
       Category.create!(:name => category[0], :description => category[1] )
       print("\r loaded: #{category[0]} to database")
    end
    
    print("\n Done loading categories #{Category.count}\n")
  end
  
  
  
  
end