require 'slack'

Slack.configure do |config|
	config.token = "xoxb-4747582215-8kzsB42AFwDDiyGUIp7kMBkx"
end

auth = Slack.auth_test
fail auth['error'] unless auth['ok']

client = Slack.realtime

client.on :hello do
	# logger.info 'Successfully connected.'
	puts "connected"
end

client.on :message do |data|
	case data['text']
		when 'makeshiftbot test'
			if data['user'] = "U02D7MQFW"
				Slack.chat_postMessage channel: data['channel'], text: "OK boss"
			end
		when 'makeshiftbot playlist stats'
			load 'get_stats.rb'
			Slack.chat_postMessage channel: data['channel'], text: "#{$counted}"
		when 'makeshiftbot playlist total'
			load 'get_stats.rb'
			Slack.chat_postMessage channel: data['channel'], text: "There are #{$number_of_tracks} tracks in the #{$playlist_name} playlist."
		end
end

client.start