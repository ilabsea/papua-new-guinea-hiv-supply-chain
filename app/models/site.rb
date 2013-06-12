class Site < ActiveRecord::Base
  belongs_to :province
  attr_accessible :address, :contact_name, :email, 
                  :land_line_number, :lat, :lng, :mobile, 
                  :name, :number_of_deadline_sumission, :order_frequency, :order_start_at, 
                  :service_type, :suggestion_order, :test_kit_waste_acceptable, :province_id

  
  validates :address, :contact_name, :email, 
            :land_line_number, :lat, :lng, :mobile, 
            :name, :number_of_deadline_sumission, :order_frequency, :order_start_at, 
            :service_type, :suggestion_order, :test_kit_waste_acceptable, :province_id , :presence   =>  true
  
  SeviceType = ["ART", "VCCT"]

  has_many :users

end
