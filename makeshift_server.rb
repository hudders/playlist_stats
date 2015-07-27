require 'slack'

$stdout.sync = true

Slack.configure do |config|
	config.token = ENV['SLACK_API_TOKEN']
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
	Slack.chat_postMessage channel: "D04MZMCPB",
						   as_user: true,
						   text: "Ready."
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
		reply(data, "http://tinyurl.com/mxdkube")
    when /^<@U04MZH46B>: who added (.*?)$/
    	reply(data, whoAdded($1.to_s))
	when /^<@U04MZH46B>: now playing$/
		reply(data, nowPlaying)
	when /^<@U04MZH46B>: (list|help)$/
		reply(data, "Here's a complete list of commands I accept:
			stats - show how many tracks each person has added to the playlist.
			total - show the total number of tracks in the playlist.
			latest - show the last track added to the playlist and who added it.
			topX artists / albums / genres - show the artists, albums or genres that appear most in the playlist, where X is the number of results to return, (eg top10 artists).
			tracks by X - show all tracks by the specified artist (eg tracks by Travis).
			genre X - show all tracks that are attributed to the specified genre (eg genre rock).
			tracks added by X - show all tracks added by a specific user (eg tracks added by Robin).
			X fave artist / genre - show the artist or genre that appears most in the submissions by the specified user (eg Tim fave artist).
			playlist link - display the URL for the Allspark playlist.
			who added X - display the name of the user who added a specific track (eg who added Fell In Love With A Girl).
			now playing - displays the name and artist of the track currently playing (if any).")
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
