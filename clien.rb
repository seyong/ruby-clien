require 'open-uri'
require 'net/http'
require 'nokogiri'

# Site Information
# - Request URL			: https://m.clien.net/service/board/news
# - Request Method	: Get
# - Content-Type		: text/html, charset=utf-8;
# - Host						: m.clien.net
# - Referer					: https://m.clien.net/service/board/news
 
class Clien
	attr_reader :host, :referer, :request_url, :od, :news
	attr_accessor :page_no

	def initialize()
		@host = "m.clien.net"
		@referer = "https://m.clien.net/service/board/news"
		@request_url = "https://m.clien.net/service/board/news"
		@od = "T31"
		@page_no = 0
		@news = Array.new
	end

	def params()
		@params = {:od => od, :po => @page_no.to_s }
		#return @params
	end

	def uri()
		@uri = URI(@request_url)
		@uri.query = URI.encode_www_form(@params)
	end
	
	def request_news()
		params()
		uri()
		res = Net::HTTP.get_response(@uri)
		# check response code is 200	
		doc = Nokogiri::HTML(res.body)
		return doc
	end

	def parse(doc)
		news_items = doc.xpath('//div[@class="list_title"]/a[@class="list_subject "]')
		puts(news_items.length)

		news_items.each do |item|
			content = Clien::News.new(item)
			@news.push(content)
			puts content
		end

	end

	class News
		#attr_reader :href, :title, :author, :date, :board_no
		attr_reader :href, :title

		def initialize(nokogiri_element)
			puts "hooray"
			@href = nokogiri_element.attributes["href"].value.to_s
			@title = nokogiri_element.text.strip
		end
	end
end
