#require 'geokit'
require 'net/http'
require 'strscan'
class MainController < ApplicationController
	def index
#	puts ".................Cookies saved from before #{cookies[:city]}..................."
	# is pagination possible?
	puts "Class of remote addr #{request.remote_addr.class}, ip: #{request.remote_addr}"
	@location = find_location_main(request.remote_addr)
#	puts "After find_location_main #{@location.class}, #{@location["country"]}, #{@location["city"]}"
	@latest_10=Event.find(:all, :order=>'id DESC',:limit=>10,:conditions=>{:flag_inappro=>false})
	todayS=Time.now.strftime("%Y-%m-%d %H:%M:00")
	todayE=Date.today.strftime("%Y-%m-%d 23:59:59")
	tomorrowS=Date.today.next.strftime("%Y-%m-%d 00:00:00")
	tomorrowE=Date.today.next.strftime("%Y-%m-%d 23:59:59")
	@events_today_noplace=0
		@events_today=Event.find(:all, :conditions=>{:time=>todayS..todayE,:flag_inappro=>false,:city=>@location["city"] })
		if @events_today.length == 0
		@events_today=Event.find(:all, :conditions=>{:time=>todayS..todayE,:flag_inappro=>false,:city=>@location["country"] })
		else
		cookies[:city]=@location["city"]
		end
	if @events_today.length ==0
		@events_today_noplace=Event.find(:all, :conditions=>{:time=>todayS..todayE,:flag_inappro=>false })
	end
	@events_tomorrow=Event.find(:all, :conditions=>{:time=>tomorrowS..tomorrowE,:flag_inappro=>false,:city=>@location["city"]})
	@events_tomorrow_noplace=0
	if @events_tomorrow.length == 0
	@events_tomorrow=Event.find(:all, :conditions=>{:time=>tomorrowS..tomorrowE,:flag_inappro=>false,:city=>@location["country"] })
	end
	if @events_tomorrow.length == 0
	@events_tomorrow_noplace=Event.find(:all, :conditions=>{:time=>tomorrowS..tomorrowE,:flag_inappro=>false })
	end
	end
	def aboutus
	#This needs to be cached
	end
	def terms
	end
protected
	def find_location_main(ip_add)
require 'timeout'
begin
#ip_add="12.215.42.19"
#ip_add="122.167.122.100"

Timeout::timeout(5) {
		http=Net::HTTP.post_form(URI.parse('http://api.hostip.info/get_html.php'), {'ip'=>ip_add})
		if http 
		location=Hash.new()
		country_str=http.body.split("\n")[0].split(":")[1].split("(")[0].strip
		city_str=http.body.split("\n")[1].split(":")[1].split(",")[0].strip
		location["country"]=country_str
		location["city"]=city_str
puts location
		return location
		end
}
rescue Timeout::Error
puts "Resolving location from ip timed out................................."
location={"country"=>"India", "city"=>"Bangalore"}
		return location
end
		
	end

end

