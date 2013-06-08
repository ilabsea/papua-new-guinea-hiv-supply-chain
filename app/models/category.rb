class Category < ActiveRecord::Base
  attr_accessible :description, :name
  
  validates :name , :presence => true
  validates :name , :uniqueness => true
end
