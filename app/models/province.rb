# == Schema Information
#
# Table name: provinces
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  code       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Province < ActiveRecord::Base
  attr_accessible :code, :name
  
  validates :name, :code , :presence   =>  true
  validates :name, :code , :uniqueness => true
  
  has_many :sites
  
  def full_description
    self.name + '(' + self.code + ')'
  end
  
end
