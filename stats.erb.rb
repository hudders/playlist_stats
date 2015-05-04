require 'rspotify'

client_id = "0fed2ff60e004c509ba2d4a484580eaf"
client_secret = "baad9e6c16f9489eaa141edba74d6d11"

RSpotify.authenticate(client_id, client_secret)

playlist = RSpotify::Playlist.find("h7dders", "4w7GeFJhl5tsIETsfglq9a")

number_of_tracks = playlist.total

playlist.tracks(limit: 100, offset: 0)
mylist = playlist.tracks_added_by.values

if number_of_tracks > 100
	playlist.tracks(limit: 100, offset: 100)
	mylist = mylist + playlist.tracks_added_by.values
end

if number_of_tracks > 200
	playlist.tracks(limit: 100, offset: 200)
	mylist = mylist + playlist.tracks_added_by.values
end

arr = Array.new

mylist.each do |x|
	moniker = x.id
	moniker.sub! "h7dders", "Hudson"
	moniker.sub! "darthspud79", "Adam"
	moniker.sub! "owennell", "Oli"
	moniker.sub! "11186053330", "Robin"
	moniker.sub! "timheap46", "Tim"
	moniker.sub! "1153680424", "Darren"
	moniker.sub! "mogriggs", "Griggs"
	moniker.sub! "11125700658", "Ragan"
	arr << moniker
end

counts = Hash.new 0

arr.each do |name|
	counts[name] += 1
end

# p number_of_tracks
# p counts.sort_by{|o,ct| [-ct,o] }

countedup = counts.sort_by{|o,ct| [-ct,o] }

puts "HTTP/1.0 200 OK\r\n"
puts "Content-type: text/html\r\n\r\n"
puts "<html><body>#{countedup}</body></html>\r\n"