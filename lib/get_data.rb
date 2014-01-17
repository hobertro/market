# GetData module is used to send HTTP requests and parse the JSON strings
require 'open-uri'
require 'awesome_print'
require 'json'

module GetData
  def parsed_data(url)
    @data = URI.parse(url).read
    JSON.parse(@data)
  end
end