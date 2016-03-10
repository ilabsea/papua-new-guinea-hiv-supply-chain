# == Schema Information
#
# Table name: backup_dbs
#
#  id         :integer          not null, primary key
#  file       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe BackupDb, type: :model do
  describe ".process" do
    it "delete keep as MAX_DB_COPY as max copy" do
      ENV['MAX_DB_COPY'] = '2'

      b1 = FactoryGirl.create(:backup_db)
      b2 = FactoryGirl.create(:backup_db)
      b3 = FactoryGirl.create(:backup_db)
      b4 = FactoryGirl.create(:backup_db)

      BackupDb.process
      expect(BackupDb.all.map(&:id)).to eq([b3.id, b4.id, b4.id + 1])
    end
  end
end
