class AddAuthCode < ActiveRecord::Migration
  def self.up
	add_column :users, :auth_code, :string
  end

  def self.down
  end
end
