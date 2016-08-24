#!/usr/bin/env ruby

# Install:
# $ cat heroku_logstalgia_formatter.rb > ~/bin/heroku_logstalgia_formatter
# $ chmod +x ~/bin/heroku_logstalgia_formatter

# Usage:
# $ heroku logs -t --app {app} | heroku_logstalgia_formatter | logstalgia -

require 'optparse'
require 'pry'
require 'date'

$stdout.sync = true
# Keep reading lines of input as long as they're coming.
while input = ARGF.gets
  input.each_line do |line|
    parts       = line.split
    next unless parts.size == 13
    timestamp   = DateTime.parse(parts[0]).to_time.to_i
    ip          = parts[7].gsub("fwd=","").gsub('"','')
    request     = parts[4].gsub("path=","").gsub('"','')
    host        = parts[5].gsub("host=","").gsub('"','')
    dyno        = parts[8].gsub("dyno=","").gsub('"','')
    status      = parts[11].gsub("status=","")
    size        = parts[12].gsub("bytes=","")

		# Custom Log Format:
		#
		# Logstalgia now supports a pipe ('|') delimited custom log file format:
		#
		#     timestamp       - unix timestamp of the request date.
		#     hostname        - hostname of the request
		#     path            - path requested
		#     response_code   - the response code from the webserver (eg 200)
		#     response_size   - the size of the response in bytes
		#
		# The following are optional:
		#     success         - 1 or 0 to indicate if successful
		#     response_colour - response colour in hexidecial (#FFFFFF) format
		#     referrer url    - the referrer url
		#     user agent      - the user agent
		#     virtual host    - the virtual host (to use with --paddle-mode vhost)
		#     pid             - process id or some other identifier (--paddle-mode pid)
    output_line = "#{timestamp}|#{ip}|#{request}|#{status}|#{size}|||||#{host}|#{dyno}"
    begin
      $stdout.puts output_line
    rescue Errno::EPIPE
      exit(74)
    end
  end
end
