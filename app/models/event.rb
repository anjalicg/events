class Event < ActiveRecord::Base
#	belongs_to :category
	belongs_to :user
	has_many :responses
	validates_presence_of :title, :description, :time, :country, :city, :location, :timezone, :message=>"- can not be empty"
	def validate
		errors.add_to_base "New event can not be in the past" if time <Time.now
	end
end
