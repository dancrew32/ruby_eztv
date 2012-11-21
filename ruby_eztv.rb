=begin

EzTv.it torrent scraper
by Series and Season

Usage:
	require 'ruby_eztv'
	tv = EzTv.new({
		:series => "Merlin", #required
		:season => 5,        #optional
	})
	puts tv.results

Command Line:
	require 'ruby_eztv'
	tv = EzTv.new({
		:series => ARGV[0],
		:season => ARGV[1],
	})
	puts tv.results

	chmod +x eztv.rb
	./eztv.rb Merlin 5

Dependencies:
	gem install mechanize

=end
class EzTv
	def initialize options={}
		require 'mechanize'

		@options = {
			:url    => "http://eztv.it/search/",
			:series => 'Merlin',
			:season => nil,
		}.merge options

		@series = @options[:series]

		no_series = @series.nil? or @series.empty?
		if no_series
			puts "You must enter a :series."
			exit	
		end

		unless @options[:season].nil?
			big = @options[:season].to_i > 9
			@s1 = big ? "s#{@options[:season]}" : "s0#{@options[:season]}"
			@s2 = "#{@options[:season]}x"
		end

		@agent = Mechanize.new

		@hit_row = false
	end

	def results
		page = @agent.post(@options[:url], {
			'SearchString1' => @options[:series]
		})
		out = ""
		page.parser.css('.forum_header_border tr[name="hover"]').each do |tr|
			tr.css('.forum_thread_post a').each do |link|
				out += parse_row_anchors link
			end
		end
		out
	end

	private

	def parse_row_anchors link
		text      = link.text
		textd     = text.downcase
		blank     = text == ""
		out       = ""
		has_title = link.attributes['title'].nil?
		title     = link.attributes['title'].value unless has_title
		mirror    = title == 'Download Mirror #1' 
		no_season = @options[:season].nil? 
		season    = no_season ? false : (textd.include?(@s1) || textd.include?(@s2)) 
		
		if season
			@hit_row = true
			out += "#{text}\n"
		else 
			if @options[:season].nil? and !blank
				@hit_row = true
				out += "#{text}\n"
			end
		end

		if mirror and @hit_row
			@hit_row = false
			out += "  #{link.attributes['href'].value}\n"
		end

		out
	end
end

