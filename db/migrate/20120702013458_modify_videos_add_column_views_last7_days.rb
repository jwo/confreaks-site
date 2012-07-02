class ModifyVideosAddColumnViewsLast7Days < ActiveRecord::Migration
  def self.up
    add_column :videos, :views_last_7, :integer, :default => 0
    add_column :videos, :views_last_30, :integer, :default => 0

    add_index :histories, :created_at
  end

  def self.down
    remove_column :videos, :views_last_7
    remove_column :videos, :views_last_30

    remove_index :histories, :created_at
  end
end
