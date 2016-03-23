# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  tip        :string(255)
#  value      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Setting < ActiveRecord::Base

  attr_accessible :value, :name, :hour

  DURATION_TYPE_HOUR = "Hour(s)"
  DURATION_TYPE_DAY  = "Day(s)"
  DURATION_TYPES     = [DURATION_TYPE_HOUR, DURATION_TYPE_DAY]


  MESSAGE_HEADERS = {
    3 => 'Acknowledgment message to site after sending message to the system'
  }

  MESSAGE_KEYS = [
    { name: :message_alerting_site_for_shipment,
      label: "Message notification of package deliver to site" ,
      params: %w(site consignment shipment_date carton_number, order_number)
    } ,
    { name: :message_asking_site,
      label: "Message check for confirmation of receiving package to site",
      params: %w(site consignment shipment_date)
    },
    { name: :message_deadline,
      label: "Message reminder to site who did not submit requisition form by deadline",
      params: %w(site deadline_date)
    },

    { name: :message_alerting_site_for_approved_order,
      label: "Message alert to site when order approved by reviewer",
      params: %w(order_number site submission_date approved_by approved_at)
    },

    { name: :site_message_success,
      label: "Acknowledgment message: Message has been sent to system successfully",
      params: %w(original_message consignment status phone_number carton_number)
    },

    { name: :site_message_error_syntax,
      label: "Acknowledgment message: Message syntax error ",
      params: %w(original_message phone_number)
    },

    { name: :site_message_invalid_consignment_number,
      label: "Acknowledgment message: Consignment number is invalid",
      params: %w(original_message phone_number)
    },

    { name: :site_message_invalid_status,
      label: "Acknowledgment message: Status is invalid",
      params: %w(original_message consignment phone_number)
    },

    { name: :site_message_invalid_carton_format,
      label: "Acknowledgment message: Invalid carton format",
      params: %w(original_message consignment status phone_number)
    },

    { name: :site_message_invalid_sender,
      label: "Acknowledgment message: Phone number is not allowed to report",
      params: %w(original_message phone_number)
    }

  ]

  def self.[](name)
    setting = get_setting name
    setting ? setting.value.to_s : ''
  end

  def self.get_setting name
     @settings ||= Setting.all
     @settings.select{|s| s.name.to_s == name.to_s }.first
  end

  def self.[]=(name, value)
    setting = Setting.find_by_name(name) || Setting.new(:name => name)
    setting.value = value
    setting.save!
    @settings = nil
    value
  end

end
