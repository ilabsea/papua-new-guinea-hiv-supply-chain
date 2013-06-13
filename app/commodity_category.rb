class  CommoityCategory < ActiveRecord::Base
  attr_accessible :name
  has_many :commodities
  
  TYPES = [ [1, "Drug"], [2, "Kit"] ]




  def display_type

  end

end
