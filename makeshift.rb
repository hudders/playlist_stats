require 'slack'
require 'sinatra'

Slack.configure do |config|
	config.token = "xoxb-4747582215-8kzsB42AFwDDiyGUIp7kMBkx"
end

auth = Slack.auth_test
fail auth['error'] unless auth['ok']

client = Slack.realtime

client.on :hello do
	logger.info 'Successfully connected.'
end

client.on :message do |data|
	case data['text']
	when 'makeshift playlist stats'
		load 'get_stats.rb'
		Slack.chat_postMessage channel: data['channel'], text: "#{$counted}"
	end
end

client.start

get '/' do
	load 'get_stats.rb'
	"#{$counted}"
end