namespace :png do
  desc "Load PNG provinces to the database" 
  task :load_provinces => :environment do
      print "Loading provinces to database\n"
      
      Province.destroy_all
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
end