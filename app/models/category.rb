class Category < ActiveRecord::Base
  attr_accessible :description, :name
  
  validates :name , :presence => true
  validates :name , :uniqueness => true

  TYPES_DRUG = '1'
  TYPES_KIT  = '2'
end
