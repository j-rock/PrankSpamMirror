require 'sinatra'
require 'twilio-ruby'

set :environment, :production
set :raise_exceptions, :false

get '/' do
  haml :index, :format => :html5
end

def grabDigits(input)
  input.scan(/[0-9]/).join("")
end

def acceptable?(number)
  # Must be eleven digit number
  /[[:digit:]]{11}/.match(number)
end

post '/phone' do
  begin
    input = Rack::Utils.escape_html(params[:phone_number])
    phone = grabDigits(input)
    raise Exception unless acceptable? phone
    account_sid = #TWILIO ACCOUNT SID
    auth_token = #TWILIO AUTH TOKEN
    @client = Twilio::REST::Client.new account_sid, auth_token
    @call = @client.account.calls.create(
      :method => 'get',
      :from => #TWILIO MOBILE PHONE
      :to => "+#{phone}",
      :url => #URL TO MP3
    )
  rescue Exception
    redirect to('/error')  
  end
  redirect to('/')
end

get '/error' do
  status 404
  haml :wut, :format => :html5
end

error do
  status 400
  haml :wut, :format => :html5
end

not_found do
  status 404
  haml :wut, :format => :html5
end
