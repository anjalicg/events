class JoinmeMailer < ActionMailer::Base
  

  def newuser(user,code,sent_at = Time.now)
#    subject    'JoinmeMailer#newuser: New user account activation'
    @subject=    'JoinMe new user account activation email'
    @recipients= user.email
    @from=       'anjalicg@gainspan.com'
    @sent_on=    sent_at
    
    @body=       "Hi, \n Welcome to JoinMe. Click the following link to activate your account and find a companion for your events http://anjalicg2001.dynalias.com/user/activate/?newauth=#{code}&email=#{user.email}"
  end

  def eventedit(responder,event,changes,sent_at = Time.now)
    @subject=    'Event edit notification from JoinMe'
    @recipients= responder[2]
    @from=       "anjalicg@gainspan.com"
    sent_on    sent_at
    
    @body=       "Dear #{responder[1] },\n  The following details regarding the Event your were interested in has changed. \n #{changes}\n You can see the changes by visiting the link http://anjalicg2001.dynalias.com/event/show/#{event.id}. If the changes do not suit you, then you can cancel your participation by visiting the link http://anjalicg2001.dynalias.com/response/list_by_responder/?user_id=#{responder[0]} \n Thank you for using JoinME!\n -The JoinMe team."

	puts "Sent mail to #{responder[1]},id=#{responder[0]}, at #{responder[2]}"
  end

  def eventdelete(responder,event,sent_at = Time.now)
    @subject=    'Event delete notification from JoinMe'
    @recipients= responder[2]
    @from=       "anjalicg@gainspan.com"
    sent_on    sent_at
    
    @body=       "Dear #{responder[1] },\n  This is to notify you that the event your were interested has been deleted. \n You might want to find new events to attend by visiting the link http://anjalicg2001.dynalias.com. You can check the status of your upcoming events by visiting the link http://anjalicg2001.dynalias.com/response/list_by_responder/?user_id=#{responder[0]} . \n Thank you for using JoinME!\n -The JoinMe team."

	puts "Sent mail to #{responder[1]},id=#{responder[0]}, at #{responder[2]}"


  end

  def addresponse(user,event,sent_at = Time.now)
    @subject=    "New response notification for your event"
    @recipients= event.user.email
    @from=       "anjalicg@gainspan.com"
    sent_on    sent_at
    
    @body= "Dear #{event.user.display_name}, \n You have a new response for your event '#{event.title}' from '#{user.display_name}'. \n You can see the user profile by visiting http://anjalicg2001.dynalias.com/user/user_home/#{user.id}. \n You can accept the response by visiting http://anjalicg2001.dynalias.com/response/list_by_event?event_id=#{event.id}.\n Thank you for using JoinME!. \n Hope you have a great time.\n -The JoinMe team."
  end
def deleteresponse(user,event,sent_at = Time.now)
    @subject=    'Participation cancellation notification for your event'
    @recipients= event.user.email
    @from=       "anjalicg@gainspan.com"
    sent_on    sent_at
    @body= "Dear #{event.user.display_name}, \n The user '#{user.display_name}' has cancelled participation for event '#{event.title}'.  \n You can see other responses for your event by visiting http://anjalicg2001.dynalias.com/response/list_by_event?event_id=#{event.id}.\n Thank you for using JoinME!. \n Hope you have a great time.\n -The JoinMe team."
  end
def acceptresponse(user,event,sent_at = Time.now)
    @subject=    'Your event participation request has been accepted'
    @recipients= user.email
    @from=       "anjalicg@gainspan.com"
    sent_on    sent_at
    @body= "Dear #{user.display_name}, \n Your request to participate in the event '#{event.title}' has been accepted.  \nYou can see the owner profile by visiting http://anjalicg2001.dynalias.com/user/user_home/#{event.user.id}.\n You can see the event details by visiting http://anjalicg2001.dynalias.com/event/show/#{event.id}\n Thank you for using JoinME!. \n Hope you have a great time.\n -The JoinMe team."
  end
    def invite_frnd(invite,sent_at = Time.now)

puts "Inside invite_frnd #{invite.mailtext.length}"
    @subject=   "Your friend #{invite.user.display_name} has invited you to join JoinMe"
puts "After subject"
    @recipients= invite.email
puts "After email"
    @from=       'anjalicg@gainspan.com'
    @sent_on=    sent_at
    @body=""
puts "Just before if loop"
    if invite.mailtext.length > 0
puts "mail text is true #{invite.name}, #{invite.mailtext}"
	@body="Dear #{invite.name}, \n  One of your friends #{invite.user.display_name} has invited your to join JoinMe. Please see their message below\n\n\n" + invite.mailtext + "\n\n\nVisit http://anjalicg2001.dynalias.com to try out our services today.\n Best Regards, \n -The JoinMe team"
else
puts "No mail text present #{invite.name}"
    @body="Dear #{invite.name}, \n  One of your friends #{invite.user.display_name} has invited your to join JoinMe. \nVisit http://anjalicg2001.dynalias.com to try out our services today.\n \n Thank you for using Join Me! \n - The Join Me team"
  end
end


    def recoverpassword(user,code,sent_at = Time.now)
    @subject=   'Reset Password link from JoinMe'
    @recipients= user.email
    @from=       'anjalicg@gainspan.com'
    @sent_on=    sent_at
    @body=	"Dear #{user.display_name}, \nWe have received your request to reset your password. \n click the following link to visit the page to reset your password.\n http://anjalicg2001.dynalias.com/user/reset_password/?resetcode=#{code}&email=#{user.email} . If you did not request to reset your password, then ignore this mail and you can continue using your old password to access our website. \n Thank you for using Join Me! \n - The Join Me team"
  end

end
