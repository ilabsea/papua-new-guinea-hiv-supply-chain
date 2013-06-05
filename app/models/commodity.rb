class Commodity < ActiveRecord::Base
  attr_accessible :commodity_category_id, :consumption_per_client_pack, :consumption_per_client_unit, :name

  belongs_to :commodity_category
end
