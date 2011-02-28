class AddExpense < ActiveRecord::Migration
  def self.up
	add_column :events, :extra_detail, :text
	add_column :users, :mail_fail, :text
	add_column :users, :mail_news, :boolean
# Add in settings to not send mail notification
	add_column :users, :login_ip, :text
	add_column :users, :accepted_terms, :boolean

  end

  def self.down
  end
end