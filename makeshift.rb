require 'slack'

Slack.configure do |config|
	config.token = "xoxb-4747582215-8kzsB42AFwDDiyGUIp7kMBkx"
end

auth = Slack.auth_test
fail auth['error'] unless auth['ok']

client = Slack.realtime

def reply(data, text)
	Slack.chat_postMessage channel: data['channel'], username: "makeshift", icon_url: "http://api.doodlecircus.co.uk/makeshift.jpg", text: text
end

client.on :hello do
	puts "connected"
end

client.on :message do |data|
	case data['text']
		when '<@U04MZH46B>: stats'
			load 'get_stats.rb'
			reply(data, "#{$counted}")
		when '<@U04MZH46B>: total'
			load 'get_stats.rb'
			reply(data, "There are #{$number_of_tracks} tracks in the #{$playlist_name} playlist.")
		end
	case data['user']
		when "U02D7MQFW"
			case data['text']
				when "<@U04MZH46B>: test"
					reply(data, "Everything's A-OK boss. :smile:")
				end
		end
end

client.start