require 'rubygems'
require 'slack'
require 'rufus/scheduler'

load 'github_status.rb'

oldgithubstatus = ""

scheduler = Rufus::Scheduler.new

$stdout.sync = true

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

scheduler.every '5m' do
	newgithubstatus = getgithubstatus
	if newgithubstatus != oldgithubstatus
		Slack.chat_postMessage channel: "D04MZMCPB",
						   as_user: true,
						   text: "github's status is " + getgithubstatus + ". :octocat:"
		oldgithubstatus = newgithubstatus
	end
end

client.on :hello do
	Slack.chat_postMessage channel: "D04MZMCPB",
						   as_user: true,
						   text: "Hello. I've been updated."
end

client.on :message do |data|
	load 'get_stats.rb'
	case data['text']
	when /^<@U04MZH46B>: (?:stats|statistics|users|tracks per user)$/
		reply(data, "#{getusers}")
	when /^<@U04MZH46B>: (?:total|total tracks|number|number of tracks)$/
		reply(data, "There are #{$number_of_tracks} tracks in the #{$playlist_name} playlist.")
	when /^<@U04MZH46B>: (?:latest|last|last added|last track)$/
		reply(data, "#{getlasttrack}")
	when /^<@U04MZH46B>: top(\d{1,2}) ((?:artists|albums|genres))$/
		reply(data, "#{top($1.to_i, $2.to_s)}")
	when /^<@U04MZH46B>: tracks by (.*)$/
		reply(data, "#{gettracksby($1.to_s)}")
	when /^<@U04MZH46B>: genre (.*)$/
		reply(data, "#{gettrackswithgenre($1.to_s)}")
	when /^<@U04MZH46B>: tracks added by (.*)$/
		reply(data, "#{gettracksaddedby($1.to_s)}")
	when /^<@U04MZH46B>: (.*) (favourite|favorite|fave) (artist|genre)$/
		reply(data, "#{getfave($1.to_s, $3.to_s)}")
	when /^<@U04MZH46B>: (?:who are you|why are you here|what are you)\?$/
		reply(data, "I am here to dispense statistics about the Decepticon team Spotify playlist. :smile:")
	when "<@U04MZH46B>: playlist link"
		reply(data, "http://tinyurl/mxdkube")
	when /^<@U04MZH46B>: (.*)$/
		case data['user']
		when "U02D7MQFW"
			case data['text']
			when "<@U04MZH46B>: test"
				reply(data, "Everything's A-OK boss. :smile:")
			end
		else
			reply(data, "No entiendo.")
		end
	end
end

client.start