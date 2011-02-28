class CreateWallentries < ActiveRecord::Migration
  def self.up
    create_table :wallentries do |t|
	t.column :entry_text, :text, :null=>false
	t.column :event_id, :integer, :null=>false
	t.column :user_id, :integer, :null=>false
	t.column :created_at, :timestamp

   end
  end

  def self.down
    drop_table :wallentries
  end
end
