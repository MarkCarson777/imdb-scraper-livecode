# yaml provides a Ruby interface for data serialisation in the Yaml format 
require "yaml"
# import scraper.rb to be able to utilise our functions
require_relative "scraper"

puts "Fetching URLs"
# execute fetch_movie_urls
urls = fetch_movie_urls

# use scrape_movie function to get the information from each movie url
movies = urls.map do |url|
  puts "Scraping #{url}"
  scrape_movie(url)
end

puts "Writing movies.yml"
# write a new file where the first argument is the name of the file and the second is our movie data being converted to yaml
File.write("movies.yml", movies.to_yaml)

puts "Done."
