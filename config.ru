require 'sinatra'
require 'tzinfo'
require 'active_support/time'
require 'active_support/core_ext/float/rounding'
require 'haml'
require 'coffee-script'

get '/' do
  haml :index
end

get '/time' do
  miami_time.now.strftime "%D %T"
end

get '/seconds' do
  now = miami_time.now
  seconds = now - now.beginning_of_day
  seconds.to_i.to_s
end

get '/beats' do
  current_beats.to_s
end

get '/miamibeats.js' do
  coffee :miamibeats
end

helpers do
  def miami_time
    @miami_time ||= TZInfo::Timezone.get('America/New_York')
  end

  def current_beats
    now = miami_time.now
    seconds = now - now.beginning_of_day
    total_seconds = now.end_of_day - now.beginning_of_day
    (seconds / total_seconds) * 1000
  end
end

run Sinatra::Application
