class AddInappropriateContents < ActiveRecord::Migration
  def self.up
	add_column :events, :flag_inappro, :boolean, :default=>false
	add_column :events, :inappro_comment, :text
	add_column :events, :tagged_by, :string
  end

  def self.down
  end
end
