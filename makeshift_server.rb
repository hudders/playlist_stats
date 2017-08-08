require 'slack'

$stdout.sync = true

token1 = ENV['SLACK_API_TOKEN']
token2 = ENV['SLACK_API_TOKEN_2']

ctm = Slack::Client.new token: token1
wlk = Slack::Client.new token: token2

rtm_ctm = ctm.realtime
rtm_wlk = wlk.realtime

def reply(data, text)
	wlk.chat_postMessage channel: "G6KQPSEDT",
						as_user: true,
						text: text
end

rtm_ctm.on :hello do
	wlk.chat_postMessage channel: "U21BNDFJ8",
						as_user: true,
						text: "CTM Ready."
end

rtm_wlk.on :hello do
	wlk.chat_postMessage channel: "U21BNDFJ8",
						as_user: true,
						text: "ChickenPicnic Ready."
end

rtm_ctm.on :message do |data|
	reply(data['text'])
end

rtm_ctm.start
rtm_wlk.start
