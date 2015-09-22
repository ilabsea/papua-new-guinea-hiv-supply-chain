# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Category < ActiveRecord::Base
  attr_accessible :description, :name
  
  validates :name , :presence => true
  validates :name , :uniqueness => true

  TYPES_DRUG = '1'
  TYPES_KIT  = '2'
end
