class AddAttributionToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :attribution, :text
    add_column :videos, :use_event_note_for_attribution, :boolean, :default => false
  end

  def self.down
    remove_column :videos, :attribution
    remove_column :videos, :user_event_note_for_attribution
  end
end
