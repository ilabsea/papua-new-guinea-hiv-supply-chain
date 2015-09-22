# == Schema Information
#
# Table name: site_messages
#
#  id                 :integer          not null, primary key
#  message            :text
#  site_id            :integer
#  status             :string(255)
#  consignment_number :string(255)
#  guid               :string(255)
#  from_phone         :string(255)
#  error              :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  response_message   :string(255)
#  carton             :integer
#  shipment_id        :integer
#

require 'spec_helper'

describe SiteMessage do
end
