require 'rufus/scheduler'
require 'httparty'

def whatisplaying
	nowplaying = `mpc current`
	HTTParty.post("http://mwhtest.sergei.io", :body => {:data => "#{nowplaying}"}.to_json)
end

scheduler = Rufus::Scheduler.new

scheduler.every '2m' do
	mpcstatus = `mpc status`
	case mpcstatus
	when /^(.*?)\[paused\](.*?)$/
		`mpc toggle`
	else
		whatisplaying
	end
end

scheduler.every '20s' do
	whatisplaying
end

testTheWater = ""
while testTheWater.lines.count < 2 do
	testTheWater = `mpc lsplaylists`
end
# `mpc add spotify:user:h7dders:playlist:4w7GeFJhl5tsIETsfglq9a`
`mpc load 'AllSpark by h7dders'`
`mpc repeat on && mpc shuffle && mpc play`

scheduler.join