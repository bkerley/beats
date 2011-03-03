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

run Sinatra::Application
