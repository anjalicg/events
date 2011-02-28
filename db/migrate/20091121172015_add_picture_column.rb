class AddPictureColumn < ActiveRecord::Migration
  def self.up
	remove_column :users, :picture
	add_column :users, :content_type, :string, :default=>"image/png"
  add_column :users, :picture, :binary
	#execute 'ALTER TABLE users ADD COLUMN picture LONGBLOB'
  end

  def self.down
	remove_column :users, :content_type
  end
end
