

$stdout.sync = true

class CTM
	include Slack
end

class ChickenPicnic
	include Slack
end

CTM.configure do |config|
	config.token = ENV['SLACK_API_TOKEN']
end

ChickenPicnic.configure do |config|
	config.token = ENV['SLACK_API_TOKEN_2']
end

auth = CTM.auth_test
fail auth['error'] unless auth['ok']

auth2 = ChickenPicnic.auth_test
fail auth2['error'] unless auth2['ok']

client = CTM.realtime
client2 = ChickenPicnic.realtime

def reply(data, text)
	ChickenPicnic.chat_postMessage channel: "G6KQPSEDT",
						as_user: true,
						text: text
end

client.on :hello do
	ChickenPicnic.chat_postMessage channel: "U21BNDFJ8",
						as_user: true,
						text: "CTM Ready."
end

client2.on :hello do
	ChickenPicnic.chat_postMessage channel: "U21BNDFJ8",
						as_user: true,
						text: "ChickenPicnic Ready."
end

client.on :message do |data|
	reply(data['text'])
end

client.start
client2.start
