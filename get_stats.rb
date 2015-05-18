require 'rspotify'

client_id = "0fed2ff60e004c509ba2d4a484580eaf"
client_secret = "baad9e6c16f9489eaa141edba74d6d11"
playlist_id = "4w7GeFJhl5tsIETsfglq9a"

RSpotify.authenticate(client_id, client_secret)

Playlist = RSpotify::Playlist.find("h7dders", playlist_id)

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
	moniker.sub! "deborahclare-gb", "Debbie"
	moniker
end

def countup(list)
	counts = Hash.new 0
	list.each do |name|
		counts[name] += 1
	end
	counts.sort_by{|o,ct| [-ct,o] }
end

def getplaylistinfo

	offset = ($number_of_tracks/100.to_f).ceil
	$x = 0

	$tracklist = []
	$userlist = []

	while $x < offset do
		listSize = ($x*100)
		Playlist.tracks(limit: 100, offset: listSize)
		$tracklist = $tracklist + Playlist.tracks(limit: 100, offset: listSize)
		$userlist = $userlist + Playlist.tracks_added_by.values
		$x +=1
	end
end

def getusers
	getplaylistinfo
	arr = Array.new

	$userlist.each do |x|
		moniker = convertuserid(x.id)
		arr << moniker
	end

	countup(arr)
end

def top(number, type)
	getplaylistinfo
	arr = Array.new
	$tracklist.each do |track|
		case type
			when "artists"
				track.artists.each do |artist|
					arr << artist.name
				end
			when "albums"
				arr << track.album.name + " (" + track.artists[0].name + ")"
			when "genres"
				track.artists.each do |artist|
					artist.genres.each do |genre|
						arr << genre
					end
				end
			end
	end
	countup(arr).take(number)
end

def getlasttrack
	lasttrack = Playlist.tracks(limit: 1, offset: $number_of_tracks - 1)
	lastadder = Playlist.tracks_added_by.values[0].id
	lastdate  = Playlist.tracks_added_at.values[0].strftime("%d/%m/%Y")

	lasttrack.last.name + " - " + lasttrack.last.artists[0].name + " added by "	+ convertuserid(lastadder) + " on " + lastdate
end

def gettracksby(x)
	getplaylistinfo
	arr = Array.new
	$tracklist.each do |track|
		track.artists.each do |artist|
			case artist.name
				when x
					arr << track.name
				end
		end
	end
	arr
end

def gettrackswithgenre(x)
	getplaylistinfo
	arr = Array.new
	$tracklist.each do |track|
		track.artists.each do |artist|
			artist.genres.each do |genre|
				case genre
					when x
						arr << track.name + " (" + artist.name + ")"
					end
			end
		end
	end
	arr
end

def gettracksaddedby(x)
	getplaylistinfo
	arr = Array.new
	count = 0
	$userlist.each do |user|
		count += 1
		moniker = convertuserid(user.id)
		case moniker
			when x
				track = $tracklist[count - 1]
				arr << track.name + " (" + track.artists[0].name + ")"
			end
	end
	arr
end

def getfave(name, type)
	getplaylistinfo
	arr = Array.new
	count = 0
	$userlist.each do |user|
		count += 1
		moniker = convertuserid(user.id)
		case moniker
			when name
				track = $tracklist[count - 1]
				case type
					when "artist"
						arr << track.artists[0].name
					when "genre"
						track.artists.each do |artist|
							artist.genres.each do |genre|
								arr << genre
							end
						end
					end
			end
	end
	name + "'s favourite " + type + " is " + countup(arr).take(1)[0][0].to_s
end

def whoAdded(trackName)
	getplaylistinfo
	count = 0
	$tracklist.each do |track|
		count += 1
		case track.name
		when trackName
			trackId = count
			break
		end
	end
	convertuserid($userlist[count].id)
end