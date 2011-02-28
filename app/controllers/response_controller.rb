class ResponseController < ApplicationController
before_filter :logged_in?
	def add
#	redirect_to :controller=>'main',:action=>'index' if session[:user].blank? 
	@response=Response.new
	@response.user_id=params[:user_id]
	@response.event_id=params[:event_id]
	@response.response=params[:responses][:response]
	if @response.save
	#puts "Response saved for #{params[:event_id]} by #{params[:user_id]}"
	#puts "#{@response.user.display_name}, #{@response.event.title},#{@response.event.user.email}"
#	JoinmeMailer.deliver_addresponse(@response.user,@response.event)
	flash[:notice]= "You have successfully responded to the event. Your contact details have been sent to the event owner."
	else
	#puts "something went wrong in saving the response"
	flash[:error]="Your response could not be sent to the event owner. Please try after some time."
	end
	#redirect_to :controller=>'user', :action=>'user_home',:id=>@response.user_id
	redirect_to :controller=>'main', :action=>'index'
	end

	def accept
	@response=Response.find(params[:response_id])
	@response.accept=true
	if @response.update_attributes(params[:response])
	#puts "Response accepted"
	flash[:notice]="You have accepted the response sent by #{@response.user.display_name}"
#	JoinmeMailer.deliver_acceptresponse(@response.user, @response.event)
	redirect_to :controller=>'response',:action=>'list_by_event',:event_id=>params[:event_id]
	else
	#puts "Response rejected"
	end
	end

	def delete
	@response=Response.find(params[:id])
	#puts @response.id, @response.created_at
	user=@response.user.id
	usr_obj=@response.user
	event_obj=@response.event
	#puts "#{@response.user.display_name}, #{@response.event.title},#{@response.event.user.email}"
	@response.destroy
#	JoinmeMailer.deliver_deleteresponse(usr_obj,event_obj)
	redirect_to :controller=>'response', :action=>'list_by_responder',:user_id=>user
	end

	def list_by_responder
	@responses=Response.find(:all, :conditions=>{:user_id=>params[:user_id]})
	@responses.each {|r|
	#puts r.event}
	end

	def list_by_event
	@event=Event.find(params[:event_id])
	@responses=Response.find(:all, :conditions=>{:event_id=>params[:event_id]})
	end
end
