require 'sinatra'

get '/' do
	load 'get_stats.rb'
	"#{$counted}"
end