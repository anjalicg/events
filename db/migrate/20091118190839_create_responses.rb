class CreateResponses < ActiveRecord::Migration
  def self.up
    create_table :responses do |t|
	t.column :user_id, :integer, :null=>false
	t.column :event_id, :integer, :null=>false
	t.column :accept, :boolean
	t.column :created_at, :timestamp
    end
  end

  def self.down
    drop_table :responses
  end
end
