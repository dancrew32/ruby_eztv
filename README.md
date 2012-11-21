ruby_eztv
=========

EzTv.it Torrent Scraper by Series and Season

== Usage:

```ruby
	require 'ruby_eztv'
	tv = EzTv.new({
		:series => "Merlin", #required
		:season => 5,        #optional
	})
	puts tv.results
```

== Command Line:

```ruby
	#!/usr/bin/env ruby
	require 'ruby_eztv'
	tv = EzTv.new({
		:series => ARGV[0],
		:season => ARGV[1],
	})
	puts tv.results
```

```bash
	chmod +x eztv.rb
	./eztv.rb Merlin 5
```

== Dependencies:
	`gem install mechanize`
