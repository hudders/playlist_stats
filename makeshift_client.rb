require 'rufus/scheduler'

def nowplaying
	(`mpc -f "[%title%]" status`).lines[0].delete("\n")
end

scheduler = Rufus::Scheduler.new

scheduler.every '2m' do
	mpcstatus = `mpc status`
	case mpcstatus
	when /^(.*?)\[paused\](.*?)$/
		`mpc toggle`
	end
end

schedule.in '1s' do
	testTheWater = ""
	while testTheWater.lines.count < 2 do
		testTheWater = `mpc lsplaylists`
	end
	`mpc load 'AllSpark by h7dders'`
	`mpc repeat on && mpc shuffle && mpc play`
	Slack.chat_postMessage channel: "D04MZMCPB",
						   as_user: true,
						   text: nowplaying
end

scheduler.join