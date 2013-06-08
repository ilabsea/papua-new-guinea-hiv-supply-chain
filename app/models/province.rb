class Province < ActiveRecord::Base
  attr_accessible :code, :name
  
  validates :name, :code , :presence   =>  true
  validates :name, :code , :uniqueness => true
  
  has_many :sites
  
  def full_description
    self.name + '(' + self.code + ')'
  end
  
end
