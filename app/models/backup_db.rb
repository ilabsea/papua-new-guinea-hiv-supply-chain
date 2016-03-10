# == Schema Information
#
# Table name: backup_dbs
#
#  id         :integer          not null, primary key
#  file       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BackupDb < ActiveRecord::Base
  attr_accessible :file
  mount_uploader :file, BackupDbUploader

  def self.process
    last_backup = BackupDb.last

    if(last_backup)
      last_id = last_backup.id
      keep_last = last_id - ENV['MAX_DB_COPY'].to_i
      BackupDb.where(["id <= ?", keep_last ]).destroy_all
    end

    backup = BackupDb.new
    file_name= "#{Time.zone.now.strftime('%Y_%m_%d_%H_%m_%s')}-#{ENV['DATABASE_NAME']}.sql"
    backup_file = File.join(Rails.root, 'tmp', '', file_name )

    command = "mysqldump -u #{ENV['DATABASE_USER']} #{ENV['DATABASE_NAME']} > #{backup_file}"
    system command #keep and return back to ruby process
    backup.file = File.open(backup_file)
    backup.save!
  end
end
