class ModifyVideosAddColumnsAggregateViews < ActiveRecord::Migration
  def self.up
    add_column :videos, :views, :integer, :default => 0
    add_column :videos, :views_updated_at, :datetime
  end

  def self.down
    remove_column :videos, :views
    remove_column :videos, :views_updated_at
  end
end
