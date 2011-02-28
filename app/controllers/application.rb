# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	layout 'standard'
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
#  protect_from_forgery # :secret => '45b87357cb27578ded7e1f505769ecdc'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
def clear_errs
puts "Inside clear flash"
flash[:error]=""
flash[:notice]=""
end
def logged_in?
unless session[:user]
flash[:notice]="You should be logged in to perform the requested action"
redirect_to :controller=>'main', :action=>'index'
else
return true
end
end
def self_added?(obj)
# obj can be event or response
if session[:user]==obj.user
return true
else
return false
end
end
def use_ssl
puts "Use ssl"
redirect_to :protocol=>"https://" unless (request.ssl?)
end
end
