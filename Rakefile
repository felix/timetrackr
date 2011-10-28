require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'echoe'
Echoe.new('timetrackr') do |g|
  g.author = 'Felix Hanley'
  g.email = 'felix@seconddrawer.com.au'
  g.summary = 'A simple time tracking utility'
  g.url = 'https://github.com/felix/timetrackr'
end
