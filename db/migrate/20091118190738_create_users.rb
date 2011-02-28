class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
	t.column :display_name, :string, :null => false, :limit=>50
	t.column :email, :string, :null=>false
	t.column :dob, :date
	t.column :gender, :string, :limit=>2
	t.column :mobile, :string
	t.column :picture, :binary, :limit=>3.megabytes
	t.column :mobile_auth , :boolean
	t.column :email_auth, :boolean
	t.column :password, :string, :null=>false
	t.column :about, :text
	t.column :interests, :text
	t.column :created_at, :timestamp
	t.column :extra, :text 
# extra is for storing IP during creation, timezone and any other info
    end
  end

  def self.down
    drop_table :users
  end
end
