# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :requisition_report do
  	site { FactoryGirl.create :site}
  	user { FactoryGirl.create :user_site }
  	form do 
  	   file = File.expand_path('../../models/data/requisition_report.xls', __FILE__)
  	   File.open(file)
  	end
  end
end
