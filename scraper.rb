# a wrapper that provides us with a simpler interface for reading from a file
require "open-uri"
# https://rubyapi.org/3.0/o/uri
# a gem that provides us with an API for reading, writing, modifying and querying documents
# https://nokogiri.org/index.html
require "nokogiri"

# information about what browser and operating systems we are using
# ruby constants are values that won't change and are defined outside of the function
USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"

def fetch_movie_urls
  # create a variable storing our target url
  top_url = "https://www.imdb.com/chart/top"
  # Nokogiri::HTML.parse creates an Nokogiri html document. URI.parse creates a URI subclass instance from the that string we pass.
  doc = Nokogiri::HTML.parse(URI.parse(top_url).open("Accept-Language" => "en-US", "User-Agent" => USER_AGENT).read)
  # use the Nokogiri search method to find and store a Nokogiri nodeset (array) of movie link tags to the movies variable
  movies = doc.search(".titleColumn a")
  # take first five of those movie link tags and loop over them
  movies.take(5).map do |movie|
    # extract the href value from the movie using the Nokogiri attributes method and convert into URI
    uri = URI.parse(movie.attributes["href"].value)
    # use the URI to build out the full url we need
    uri.scheme = "https"
    uri.host = "www.imdb.com"
    uri.query = nil
    # convert it to a string
    uri.to_s
  end
end

def scrape_movie(url)
  # parse our individual movie url into the same format to be able to extract the movie information
  doc = Nokogiri::HTML.parse(URI.parse(url).open("Accept-Language" => "en-US", "User-Agent" => USER_AGENT).read)
  # retrieve and store movie information into the appropriate variables by using CSS selectors with the Nokogiri search method
  title = doc.search("h1").text
  year = doc.search(".ipc-link.ipc-link--baseAlt.ipc-link--inherit-color.sc-f26752fb-1.hMnkBf").text.to_i
  storyline = doc.search(".sc-6cc92269-0.iNItSZ").text
  # :contains pseudo selector that will look for element with the class `ipc-metadata-list__item` and contains the text `Director`
  director = doc.search('.ipc-metadata-list__item:contains("Director") a').first.text
  cast = doc.search('.ipc-metadata-list__item:contains("Stars") a.ipc-metadata-list-item__list-content-item').map { |element| element.text }.uniq

  # create a hash that will store all of the information for the movie
  {
    title: title,
    cast: cast,
    director: director,
    storyline: storyline,
    year: year
  }
end
