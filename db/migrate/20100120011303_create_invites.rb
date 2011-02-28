class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
t.column :email, :string, :null=>false
	t.column :user_id, :integer, :null=>false
	t.column :join_status, :integer, :default=>0
#0->invite sent but not yet joined, 1-> already a member so invite was not sent
	t.column :name, :string
	t.column :mailtext , :text
	t.column :created_at, :timestamp
    end
  end

  def self.down
    drop_table :invites
  end
end
