class AddProfileViews < ActiveRecord::Migration
  def self.up
	add_column :users, :view_count, :integer
	add_column :events, :view_count, :integer
  end

  def self.down
  end
end
