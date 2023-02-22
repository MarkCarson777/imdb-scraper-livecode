require_relative "../scraper"

# give the test a name
describe "#fetch_movie_urls" do
  # provide a condition for the test
  it "returns an array of movies" do
    # execute our function from scraper.rb and store the results in the urls variable
    urls = fetch_movie_urls
    # we provide the test with the results we expect
    expected = [
      "https://www.imdb.com/title/tt0111161/",
      "https://www.imdb.com/title/tt0068646/",
      "https://www.imdb.com/title/tt0468569/",
      "https://www.imdb.com/title/tt0071562/",
      "https://www.imdb.com/title/tt0050083/"
    ]
    # use rspec to compare the expected results to the actual results
    expect(urls).to eq(expected)
  end

  describe "#scrape_movie" do
    it "returns a Hash describing a movie" do
      the_dark_knight_url = "https://www.imdb.com/title/tt0468569/"
      movie = scrape_movie(the_dark_knight_url)

      expected = {
        cast: ["Christian Bale", "Heath Ledger", "Aaron Eckhart"],
        director: "Christopher Nolan",
        storyline: "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
        title: "The Dark Knight",
        year: 2008
      }
      expect(movie).to eq(expected)
    end
  end
end