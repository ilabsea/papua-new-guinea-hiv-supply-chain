# == Schema Information
#
# Table name: requisition_reports
#
#  id         :integer          not null, primary key
#  form       :string(255)
#  site_id    :integer
#  user_id    :integer
#  status     :string(255)      default("PENDING")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
