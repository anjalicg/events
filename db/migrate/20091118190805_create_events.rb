class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
	t.column :user_id, :integer, :null=>false
	t.column :category_id, :integer, :null=>false
	t.column :title, :string
	t.column :description, :text
	t.column :location, :string
	t.column :country, :string
	t.column :city, :string
	t.column :time, :timestamp
	t.column :active, :boolean
	t.column :timezone, :string
	t.column :created_at, :timestamp
    end
  end

  def self.down
    drop_table :events
  end
end
