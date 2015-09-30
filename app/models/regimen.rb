# == Schema Information
#
# Table name: regimen
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  regimen_category_id :integer
#  unit_id             :integer
#  strength_dosage     :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Regimen < ActiveRecord::Base
  belongs_to :regimen_category
  belongs_to :unit
  has_many :commodities, dependent: :nullify

  attr_accessible :name, :strength_dosage, :regimen_category_id, :unit_id

  validates :name, :regimen_category_id, :unit_id, presence: true
  validates :name, uniqueness: true
end
