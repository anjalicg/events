class WallentryController < ApplicationController
before_filter :logged_in?
def new
	@walle=Wallentry.new()
	##puts "Walle #{@walle}"
	case request.method
	when :post
	@walle=Wallentry.new(params[:wallentry])
	@walle.event_id=params[:event_id]
	@walle.user_id=session[:user].id
	if @walle.save
	##puts "plan entry saved successfully"
	redirect_to :controller=>"event",:action=>"show", :id=>params[:event_id]
	else
	##puts "plan entry sould not be saved"
	flash[:error]="Plan changes could not be saved.Please try again after some time."
	redirect_to :controller=>"event",:action=>"show", :id=>params[:id]
	end
	end
end
def edit

@walle=Wallentry.find(:id)
@can_edit= (@walle.user_id==session[:user].id ||@walle.event.user_id==session[:user].id)?true:false
##puts "Can edit for wall entry? #{@walle.}"
end
def del
end



end
