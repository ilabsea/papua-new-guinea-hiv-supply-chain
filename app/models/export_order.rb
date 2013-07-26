require 'csv'
class ExportOrder 
	def self.as_csv file
	  CSV.open(file, "wb") do |csv|
	  	headers = ['Summition', 'Site',	'Id', 'Order Creation','Entry', 'Reviewer', 'Reviewed Date', 'Status']
  		csv << headers
  		Order.find_each do |order|
  			csv << [ order.date_submittion, 
  					 order.site.name,
  					 order.id,
  					 order.order_date,
  					 order.user_data_entry ? order.user_data_entry.user_name : "",
  					 order.review_user ?  order.review_user.user_name : "",
  					 order.review_date ,
  					 order.status 
  			]
  		end
	  end
	end
end