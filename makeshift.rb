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
		when 'makeshiftbot status'
			Slack.chat_postMessage channel: data['channel'], text: "A-OK boss"
		when 'makeshiftbot playlist stats'
			load 'get_stats.rb'
			Slack.chat_postMessage channel: data['channel'], text: "#{$counted}"
		end
end

client.start