class AddResponseText < ActiveRecord::Migration
  def self.up
	add_column :responses, :response, :text

  end

  def self.down
  end
end
