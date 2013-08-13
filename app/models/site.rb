class Site < ActiveRecord::Base
  belongs_to :province
  attr_accessible :address, :contact_name, :email, :in_every, :duration_type,
                  :land_line_number, :lat, :lng, :mobile, 
                  :name, :number_of_deadline_sumission, :order_frequency, :order_start_at, 
                  :service_type, :suggestion_order, :test_kit_waste_acceptable, :province_id

  
  validates :contact_name,:land_line_number, :mobile, :name, :number_of_deadline_sumission, :order_frequency, :order_start_at, 
            :service_type, :suggestion_order, :test_kit_waste_acceptable, :province_id , :presence   =>  true
     
  
  SeviceType = ["ART", "VCCT"]
  default_scope order('sites.name ASC')

  has_many :users
  has_many :requisition_reports
  has_many :orders

end
