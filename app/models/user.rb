class User < ActiveRecord::Base
#	act_as_mappable
	has_many :events
	has_many :responses
	HUMANIZED_COLUMNS = {:email => "Email ID", :display_name=>"Display Name"}
	validates_uniqueness_of :email, :message=>": Already Exists"
	validates_format_of :email,:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message=>': Should be a valid email address to which account activation email 		can be sent.'
	validates_confirmation_of :password, :message=>": Did not match the confirmation"
	validates_presence_of :display_name,:email,:password, :message=> ": Can't be blank"
	#validates_format_of :picture_field, :in=>["gif", "png","jpg"]
	#validates_filesize_of :picture, :in=>0..1.kilobytes

	def self.human_attribute_name(attribute)
		HUMANIZED_COLUMNS[attribute.to_sym] || super
	end
	def pictureimg=(picture_field)
	  return if picture_field.blank?
puts "Picture size is #{picture_field.size}"
	  self.content_type = picture_field.content_type.chomp
	  self.picture = picture_field.read
	end

	def validate
		#errors.add "Picture", "Image size should be less than 4KB" if picture.size >4.kilobytes
	end	



end
