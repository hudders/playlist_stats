require 'open-uri'
require 'json'

def getgithubstatus
	response = open('https://status.github.com/api/status.json').read
	hash = JSON[response]
	"github's status is " + hash['status'] + ". :octocat:"
end