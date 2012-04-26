class ModifyVideosAddColumnYoutubeCode < ActiveRecord::Migration
  def self.up
    add_column :videos, :youtube_code, :string
  end

  def self.down
    remove_column :videos, :youtube_code
  end
end
