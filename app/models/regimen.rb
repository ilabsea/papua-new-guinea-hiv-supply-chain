class Regimen < ActiveRecord::Base
  belongs_to :regimen_category
  belongs_to :unit
  attr_accessible :name, :strength_dosage, :regimen_category_id, :unit_id

  validates :name, :regimen_category_id, :unit_id, presence: true
  validates :name, uniqueness: true
end
