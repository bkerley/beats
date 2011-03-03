require 'sinatra'
require 'tzinfo'
require 'active_support/time'

miami_time = TZInfo::Timezone.get('America/New_York')

get '/' do
  'Hello Design Miami'
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
  now = miami_time.now
  seconds = now - now.beginning_of_day
  total_seconds = now.end_of_day - now.beginning_of_day
  beats = (seconds / total_seconds) * 1000

  beats.to_s
end

run Sinatra::Application
