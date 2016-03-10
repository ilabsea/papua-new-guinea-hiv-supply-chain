# == Schema Information
#
# Table name: backup_dbs
#
#  id         :integer          not null, primary key
#  file       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :backup_db do
    file File.open(File.expand_path('../../models/data/test_backup.sql', __FILE__))
  end
end
