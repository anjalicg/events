class InviteController < ApplicationController
def friend
@friend = Invite.new()
case request.method
when :post
@friend=Invite.new(params[:invite])
@friend.user_id=session[:user].id
#puts "Posting Invites......... #{@friend}"
present= ((User.find(:first, :conditions=>{:email=>@friend.email})) or (Invite.find(:first, :conditions=>{:email=>@friend.email}))) 
# Need to check on this.. I think no need to re-send the invite..
#puts ".................IS IT PRESENT #{present}..........................."
if present
@friend.join_status=1
#puts "No need to send invite"
flash[:notice]="Your friend with email address '#{@friend.email}' is already a member with us. So we have not sent a new invitation."
else
@friend.join_status=0
@friend.save
#puts "New user, need to send invite"
if @friend.save
#puts "Invite saved in the database"
JoinmeMailer.deliver_invite_frnd(@friend)
flash[:notice]="An invitation mail has been successfully sent to your friend. Thank you for your help in spreading word about us."
else

#puts "Invite could not be saved"
flash[:error]="Some error happened, please try again after some time."
end # if @friend.save
end #if
end #case

end #function
end
