class EventController < ApplicationController
before_filter :logged_in?, :except=>[:show,:list_by_place,:list_by_user,:get_list_by_place]
	def add
#	Redirect to main page if the user is not logged in
#	redirect_to :controller=>'main',:action=>'index' if session[:user].blank? 
#	create new event, http get
	@event=Event.new()
	case request.method
	when :post
# 	Http post, event is saved with the entered information like what, when, where and description
	@event=Event.new(params[:event])
	@event.user=session[:user]
	@event.category_id =0
	@event.view_count=0
	if @event.save
	flash[:notice]="Event created successfully"
# 	go to user home after saving the event.
#	redirect_to :controller=>'user',:action=>'user_home',:id=>@event.user.id
	redirect_to :controller=>'main',:action=>'index'
	end
	end
	end
	
	def edit
#	Redirect to main page is user is not logged in
#	redirect_to :controller=>'main',:action=>'index' if session[:user].blank? 
	@event=Event.find(params[:id])
	@event_old=Event.find(params[:id])
	unless @event.user==session[:user]
# If the logged-in user is not the creater of the event, then redirect to the logged-in user's home page
	flash[:error] = "You can only edit events created by you"
#	redirect_to :controller=>'user', :action=>'user_home', :id=>session[:user].id
	redirect_to :controller=>'main', :action=>'index'
	end
	case request.method
	when :post
#	Save the changes submitted for the event.
	if @event.user==session[:user]
	#puts "Going to update_attributes #{params[:event]} ................................."
	id=@event.id
	if @event.update_attributes(params[:event])
	@event_new=Event.find(id)
	# Send mail to responders with event edit details
	# checking with hard coded values
	responses=Response.find(:all, :select=>:user_id, :conditions=>{:event_id=>@event.id})
	#puts responses
	user_email=responses.collect {|y| user=User.find(y.user_id)
	[y.user_id, user.display_name, user.email]
	}	
	##puts user_id
#puts ".......>"
	#puts user_email, user_email.class, user_email.length
#puts ".......>"
	user_email.each {|usr_email|
	#puts "<-----------------Inside user_email.each------------------>"
	#puts usr_email, usr_email.class,usr_email.length
	JoinmeMailer.deliver_eventedit(usr_email,@event, compare_event (@event_old, @event_new))
	}
	flash[:notice]="Event details updated successfully"
# Write block for sending mail to event responders with the new details of the event.
#	Redirect to user home
#	redirect_to :controller=>'user',:action=>'user_home',:id=>@event.user.id
	redirect_to :controller=>'main',:action=>'index'
	end #If event is saved successfully
	else
	flash[:error] = "You can only edit events created by you"
	end # End of checking if the session user is same as event user
	end # End of case
	end # End of function
	
	def delete
	@event=Event.find(params[:id])
# 	Only logged-in user who created the event, can delete the event
	if @event.user==session[:user]
		user_id=@event.user.id
		event_id=@event.id
		@responses=Response.find(:all, :conditions=>{:event_id=>event_id})
		@event.destroy
	flash[:notice]="Event was removed successfully"
	responses=Response.find(:all, :select=>:user_id, :conditions=>{:event_id=>event_id})
	#puts responses
	user_email=responses.collect {|y| user=User.find(y.user_id)
	[y.user_id, user.display_name, user.email]
	}	
	@responses.each {|response|
	#puts response
	response.destroy
	#puts "After deleting response #{response}"
	}
#puts ".......>"
	#puts user_email, user_email.class, user_email.length
#puts ".......>"
	user_email.each {|usr_email|
	#puts "<-----------------Inside user_email.each------------------>"
	#puts usr_email, usr_email.class,usr_email.length
	JoinmeMailer.deliver_eventdelete(usr_email,@event)
	}

		#redirect_to :controller=>'user',:action=>'user_home', :id=>user_id
		redirect_to :controller=>'main',:action=>'index'
	else
	flash[:error]="You can only delete events created by you"
	#puts "CANT delete"
	end
	end
	def inappropriate
	@event_tag=Event.find(params[:event_id])
	case request.method
	when :post
	@event=Event.find(params[:event_id])
	@event.flag_inappro=true
	@event.inappro_comment=params[:event][:inappro_comment]
	@event.tagged_by=session[:user].id
	if @event.save
	flash[:notice]="You have successfully tagged the event as inappropriate"
	#redirect_to :controller=>'user', :action=>'user_home', :id=>session[:user].id
redirect_to :controller=>'main', :action=>'index'
	end
	end
	end #End of inappropriate

	def show
	# link for created_by profile
	@event=Event.find(params[:id])
	@walles=Wallentry.find(:all, :conditions=>{:event_id=>params[:id]},:order=>"created_at DESC")
	#puts @event.flag_inappro
	if @event.flag_inappro == true
	flash[:error]="This event is no longer available since it has been tagged inappropriate"
	if session[:user]
#		redirect_to :controller=>'user', :action=>'user_home',:id=>session[:user].id
		redirect_to :controller=>'main', :action=>'index'
	else
		redirect_to :controller=>'main', :action=>'index'
	end
	end
#	Increment view_count
	unless session[:user]==@event.user
	@event.view_count +=1
	@event.save
	end
	end

	def list_by_user
	# listing events by user
	@user=User.find(params[:user_id])
	events=Event.find(:all,:conditions=>{:user_id=>@user.id},:order=>'time ASC')
#,:flag_inappro=>false 
	@upComingevents=events.map {|event| 
	if (event.time >= Time.now)
	event
	end
	}
	@expiredevents=events.map {|event| 
	if (event.time <= Time.now)
	event
	end
	}
	@responses=Hash.new(0)
	resp=Response.find(:all)
	resp.each {|response|
	@responses[response.event_id.to_s] +=1
	}
	#puts @responses.each {|k,v|
	#puts "#{k} <--> #{v}"}
	end
	def get_list_by_place
	end
	def list_by_place
	#listing events by place
	#puts request.method
	case request.method
	when :post
	events=Event.find(:all, :conditions=>{:city=>params[:search][:city],:flag_inappro=>false},:order=>'time ASC')
	@events=events.map {|event| 
	if (event.time >= Time.now)
	event
	else
	#puts "Expired event"
	end
	}
	#puts @events.length
	end
	end
protected
	def compare_event(obj_old,obj_new)
	changes=Hash.new(0)
	# title, description, location, city, country, time, timezone
	event_attrib_list=["title", "description", "location", "city", "country", "time", "timezone"]
#	#puts obj_old.read_attribute("title")
	event_attrib_list.each {|name|
	unless obj_old.read_attribute(name) == obj_new.read_attribute(name)
		changes[name.capitalize+": "]=obj_new.read_attribute(name).to_s+"\n"
	end
	}
#	#puts "The following attributes were changed"
#	changes.each {|k,v|
#	#puts "#{k} <-----> #{v}"
#	}
#	#puts ".........................End of protected function............."
#	#puts changes
	return changes
	end
	
end
