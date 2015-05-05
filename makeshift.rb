require 'slack'

Slack.configure do |config|
	config.token = "xoxb-4747582215-8kzsB42AFwDDiyGUIp7kMBkx"
end

auth = Slack.auth_test
fail auth['error'] unless auth['ok']

client = Slack.realtime

def reply(data, text)
	Slack.chat_postMessage channel: data['channel'],
						   as_user: true,
						   text: text
end

client.on :hello do
	puts "connected"
end

client.on :message do |data|
	case data['text']
		when '<@U04MZH46B>: stats'
			load 'get_stats.rb'
			reply(data, "#{getusers}")
		when '<@U04MZH46B>: total'
			load 'get_stats.rb'
			reply(data, "There are #{$number_of_tracks} tracks in the #{$playlist_name} playlist.")
		when "<@U04MZH46B>: latest"
			load 'get_stats.rb'
			reply(data, "#{getlasttrack}")
		when /^<@U04MZH46B>: top(\d+) (.*)$/
			load 'get_stats.rb'
			reply(data, "#{top($1.to_i, $2.to_s)}")
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