class Scrape
	attr_accessor :title, :hotness, :image_url, :rating, :director, :genre, :runtime, :synopsis, :failure

	def scrape_new_movie(url)
		begin
			doc = Nokogiri::HTML(open(url))
			doc.css('script').remove
			self.title = doc.at("h1#movie-title").text.strip
			self.hotness = doc.at("span.meter-value span").text.to_i
			self.image_url = doc.at_css('a#poster_link img')['src']
			self.rating = doc.at("div.info").children[3].text
			self.director = doc.at("div.info").children[11].text.strip
			self.genre = doc.at("div.info").children[7].text.strip
			self.runtime = doc.at("div.info").children[27].text.strip
      s = doc.css('#movieSynopsis').text
			if ! s.valid_encoding?
				s = s.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
			end
			self.synopsis = s.strip
			return true
		rescue Exception => e
			self.failure = "Something went wrong with the scrape"
		end
	end

end
