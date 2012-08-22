class AddLicenseToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :license, :string, :default => 'cc-by-sa-3.0'
  end

  def self.down
    remove_column :videos, :license
  end
end
