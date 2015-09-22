# == Schema Information
#
# Table name: surv_sites
#
#  id                          :integer          not null, primary key
#  import_surv_id              :integer
#  site_id                     :integer
#  month                       :string(255)
#  year                        :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  surv_site_commodities_count :integer          default(0)
#  surv_type                   :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :surv_site do
    import_id 1
    site_id 1
    month "MyString"
    year "MyString"
  end
end
