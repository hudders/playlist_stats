require 'rspotify'

client_id = "0fed2ff60e004c509ba2d4a484580eaf"
client_secret = "baad9e6c16f9489eaa141edba74d6d11"

RSpotify.authenticate(client_id, client_secret)

Playlist = RSpotify::Playlist.find("h7dders", "4w7GeFJhl5tsIETsfglq9a")

$playlist_name = Playlist.name
$number_of_tracks = Playlist.total

def convertuserid(moniker)
	moniker.sub! "h7dders", "Hudson"
	moniker.sub! "darthspud79", "Adam"
	moniker.sub! "owennell", "Oli"
	moniker.sub! "11186053330", "Robin"
	moniker.sub! "timheap46", "Tim"
	moniker.sub! "1153680424", "Darren"
	moniker.sub! "mogriggs", "Griggs"
	moniker.sub! "11125700658", "Ragan"
	moniker
end

def countup(list)
	counts = Hash.new 0
	list.each do |name|
		counts[name] += 1
	end
	counts.sort_by{|o,ct| [-ct,o] }
end

def getusers
	Playlist.tracks(limit: 100, offset: 0)
	mylist = Playlist.tracks_added_by.values

	if $number_of_tracks > 100
		Playlist.tracks(limit: 100, offset: 100)
		mylist = mylist + Playlist.tracks_added_by.values
	end

	if $number_of_tracks > 200
		Playlist.tracks(limit: 100, offset: 200)
		mylist = mylist + Playlist.tracks_added_by.values
	end

	arr = Array.new

	mylist.each do |x|
		moniker = convertuserid(x.id)
		arr << moniker
	end

	countup(arr)
end

def top(number, type)
	tracklist = Playlist.tracks(limit: 100, offset: 0)	
	if $number_of_tracks > 100
		tracklist = tracklist + Playlist.tracks(limit: 100, offset: 100)
	end
	if $number_of_tracks > 200
		tracklist = tracklist + Playlist.tracks(limit: 100, offset: 200)
	end
	case type
		when "artists"
			artistArray = Array.new
			tracklist.each do |track|
				track.artists.each do |artist|
					artistArray << artist.name
				end
			end
			countup(artistArray).take(number)
		when "albums"
			albumArray = Array.new
			tracklist.each do |track|
				albumArray << track.album.name
			end
			countup(albumArray).take(number)
		when "genres"
			genreArray = Array.new
			tracklist.each do |track|
				track.artists.each do |artist|
					artist.genres.each do |genre|
						genreArray << genre
					end
				end
			end
			countup(genreArray).take(number)
		end
end

def getlasttrack
	lasttrack = Playlist.tracks(limit: 1, offset: $number_of_tracks - 1)
	lastadder = Playlist.tracks_added_by.values[0].id
	lastdate  = Playlist.tracks_added_at.values[0].strftime("%d/%m/%Y")

	lasttrack.last.name + " - " + lasttrack.last.artists[0].name + " added by " + convertuserid(lastadder) + " on " + lastdate
end