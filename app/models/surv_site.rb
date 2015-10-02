# == Schema Information
#
# Table name: surv_sites
#
#  id                          :integer          not null, primary key
#  import_surv_id              :integer
#  site_id                     :integer
#  month                       :integer
#  year                        :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  surv_site_commodities_count :integer          default(0)
#  surv_type                   :string(255)
#

require 'spreadsheet'

class SurvSite < ActiveRecord::Base

  belongs_to :import_surv
  has_many :surv_site_commodities, :dependent => :destroy
  belongs_to :site

  attr_accessible :site_id, :site, :month, :year, :surv_site_commodities_attributes, :surv_type
  accepts_nested_attributes_for :surv_site_commodities

  before_save :copy_attr_from_import_surv
  after_save :update_number_of_patient_for_order #when order approve the surv site should not be able to edit



  def self.import book
    sheet_arv_request = book.worksheet 0
    row = sheet_arv_request.row 0
  end

  def copy_attr_from_import_surv
    self.month = self.import_surv.month
    self.year  = self.import_surv.year
    self.surv_type = self.import_surv.surv_type
  end

  def update_number_of_patient_for_order
    SyncOrderWithSurvSite.new(self).start
  end

  def self.for_site_order(order)
    site_id = order.site_id
    date = order.order_date

    SurvSite.order('id DESC').includes(:surv_site_commodities)
                             .where([' site_id = ? AND year = ? AND month = ?', site_id, date.year, date.month-1])
  end

  def self.find_surv_type site_id, date , type
    SurvSite.order('id DESC').includes(:surv_site_commodities).where([' surv_type = :surv_type AND site_id = :site_id AND year = :year AND month = :month', 
                                    :site_id => site_id, :year => date.year, :month => date.month-1, :surv_type => type]).first
  end

  def self.find_survs site_id, date
    {  
      CommodityCategory::TYPES_KIT  => find_surv_type(site_id, date , ImportSurv::TYPES_SURV1 ),
      CommodityCategory::TYPES_DRUG => find_surv_type(site_id, date , ImportSurv::TYPES_SURV2 )
    }
  end

end
