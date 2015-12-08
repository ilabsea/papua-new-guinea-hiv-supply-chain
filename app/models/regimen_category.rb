# == Schema Information
#
# Table name: regimen_categories
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class RegimenCategory < ActiveRecord::Base
  has_many :regimen

  attr_accessible :description, :name
  validates :name, uniqueness: true
  validates :name, presence: true
end
