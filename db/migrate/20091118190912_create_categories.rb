class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
	t.column :name, :string, :null=>false
	t.column :accept, :boolean
	t.column :created_at, :timestamp
    end
  end

  def self.down
    drop_table :categories
  end
end
