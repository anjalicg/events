class UserController < ApplicationController
#layout "standard", :except=>[:signup, :login, :recover_password]
before_filter :logged_in?, :except=>[:login, :signup, :recover_password,:activate,:logout,:mailsent,:reset_password]
#before_filter :use_ssl, :only=>[:login, :signup, :recover_password, :reset_password]
#before_filter :use_ssl
#before_filter :clear_errs


	def login
	case request.method
	when :post
#puts "inside login method.................................."
	params.each {|k,v|
	#puts "#{k}<-->#{v}"}
#	session[:user]= User.find(:first, :conditions=>{:email=>params[:user][:email],:password=>params[:user][:password],:email_auth=>true})
	@user = User.find(:first, :conditions=>{:email=>params[:user][:email],:password=>params[:user][:password],:email_auth=>true})
	if @user
	session[:user] = @user
		@user.login_ip=@user.login_ip.to_s+"<="+request.remote_addr+":"+Time.now.to_s+"=>"
	@user.save
	#puts "..................User found and logged in successfully"
#	redirect_to :controller=>'user', :action=>'user_home', :id=>session[:user].id
	redirect_to :controller=>'main',:action=>'index'
	else
	#puts "...................Login failed for #{params[:user][:email]} and #{params[:user][:password]}"
	flash[:login_error]="The email address or password you provided does match our records or your account is not activated. "
#	redirect_to :controller=>'main',:action=>'index'
#	redirect_to :controller=>'main',:action=>'index'
	end

	end
		
	end
	
	def mailsent
	end
	def signup
	# basic signup page, redirect to profiles
		@user=User.new()
		case request.method
		when :post
		#puts "INSIDE USER SIGNUP METHOD.............."
		@user=User.new(params[:user])
		tempauth_code=code_generate(params[:user][:email])
		@user.auth_code=tempauth_code
		@user.mail_news=true
		@user.accepted_terms=params[:accepted_terms]
		@user.login_ip=@user.login_ip.to_s+request.remote_addr
		#puts "..............................................................."
#params.each {|k,v|
	#puts "#{k} <-------------->#{v}"
#}
#puts "aceepted? #{params[:accepted_terms]}"
		#puts "..............................................................."
			if @user.save
			#session[:user]=@user
			#puts "User saved"
			JoinmeMailer.deliver_newuser(@user,tempauth_code)
			flash[:notice]="An account activation email has been sent to your address. Please follow the link provided with it to activate your account 				and starting using our services."
			return if request.xhr?
			#render :nothing=>true
			redirect_to :controller=>'main', :action=>'index'
			else
			#puts "User not saved"
			errorstr="Server:-Please correct the following errors and re-submit the form:-<br/>";
			count=1;
			@user.errors.each {|k,v|
			errorstr += "--#{count}: #{k.humanize}: #{v}<br/>"
			count +=1
			}
			#puts errorstr
			flash[:error_sign]=errorstr
			#puts @user.errors
			redirect_to :controller=>'user', :action=>'login'
			end

		end

	end
	def activate
	#puts params
	params.each {|k,v|
	#puts "#{k}<-->#{v}<--->#{v.class}"}
	@user=User.find(:first, :conditions=>{:email=>params[:email],:auth_code=>params[:newauth]})
	if @user
	#puts "User found and the auth key matches"
	@user.email_auth=true
	@user.view_count=0
	@user.save
	session[:user]=@user
#	redirect_to :controller=>'user', :action=>'user_home', :id=>@user.id
	redirect_to :controller=>'main', :action=>'index'
	else
	#puts "User not found with the mentioned mail id and auth key"
	flash[:error]="Error in activation. Please forward us your activation email and we will look into this matter immediately"
	end

	end
	def logout
	reset_session
	redirect_to :controller=>'main', :action=>'index'
	end
	def edit
	# editing profiles
	@user=User.find(params[:id])
		case request.method
		when :post
		#puts "#{params}"
		if @user.update_attributes(params[:user])
		flash[:notice]="Your profile was updated successfully"
#		redirect_to :controller=>'user', :action=>'user_home', :id=>@user.id
		redirect_to :controller=>'main', :action=>'index'
		else
			errorstr="Please correct the following errors and re-submit the form:-<br/>";
			count=1;
			@user.errors.each {|k,v|
			errorstr += "#{count}: #{k.humanize}: #{v}<br/>"
			count +=1
			}
			#puts errorstr
			flash[:error]=errorstr
			#puts @user.errors
		end
		
		
		end
	end
	def user_home
=begin
	unless session[:user]
	flash[:notice]="Please login to see user profile"
	render :partial=>'login', :controller=>'user'
	end
=end
	# only of logged in	
	@user=User.find(params[:id])
	@show_details=params[:show_details]
	#puts ".........................................."
	#puts @show_details
	unless session[:user]==@user
#	Increment view_count
	#puts "Inside increment code, #{@user.view_count}"
	@user.view_count +=1
	#puts "Inside increment code, #{@user.view_count}"
	if @user.save
	#puts "Saved successfully"
	else
	#puts "save failed #{@user.errors}"
#	@user.errors.each {|k,v|
	#puts "#{k} <-------------->#{v}"}
	#end
	end

	end
	def image
		@image=User.find(params[:id])
		send_data @image.picture, :file_name =>"photo.jpg", :type=>@image.content_type, :disposition=>'inline'
	end
def recover_password

		case request.method
		when :post
		#puts "Going to send mail to #{params[:password][:email]}"
		user=User.find(:first, :conditions=>{:email=>params[:password][:email]})
		if user
		#puts "Going to send mail to #{user}, #{user.display_name},#{user.password}"
		code=code_generate(user.email)
		user.reset_code=code
		user.save
		# send mail to params[:password][:email]
		JoinmeMailer.deliver_recoverpassword(user,code)
			flash[:notice]= "An email has been sent to your email address with a link to reset password. Please check your SPAM folder if it is not found in your inbox."
			redirect_to :controller=>'user',:action=>'mailsent'
			else
			flash[:error]="The email address you submitted does not have an account with us. Please SignUp today and be a part of this growing community. Thanks!!"
		end
		end

	end
	def reset_password
	if params[:email] and params[:resetcode]
	@user=User.find(:first, :conditions=>{:email=>params[:email], :reset_code=>params[:resetcode]})
	else
	@user = User.find(params[:id])
	end
	unless @user
	flash[:error]="Your password reset request is incorrect. If you received this email from us, please forward it to our support team and we will look into this 		matter. "
#	redirect_to :controller=>'main', :action=>'index'
	end
	#puts "User before render #{@user}"
	case request.method
	when :post
	@user=User.find(params[:id])
	#params.each {|k,v|
	#puts "#{k} <--------> #{v}"
	#}
	#puts "User object is #{@user}"
	@user.reset_code=""
	if @user.update_attributes(params[:user])
	#puts "Password reset for #{@user}, #{@user.email}.............................................."
		reset_session
		flash[:notice]="Your password has been successfully reset. Please login with your new password and continue using our services."
		redirect_to :controller=>'user', :action=>'login'
	else
			errorstr="Please correct the following errors and re-submit the form:-<br/>";
			count=1;
			@user.errors.each {|k,v|
			errorstr += "#{count}: #{k.humanize} #{v}<br/>"
			count +=1
			}
			#puts errorstr
			flash[:error]=errorstr
			#puts @user.errors
	end
	end
	end
	
#=============================================================
	protected 
	def code_generate(email)
	code=Array.new()
	for i in 0..50
	code.push(rand(9))
	end
	#puts code.to_s
	return code.to_s	
	end

end
