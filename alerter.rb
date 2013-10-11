require 'twilio-ruby'
require 'httparty'
require 'json'

class Alerter
  def check(model, zip)
    sleep 1 # be nice to apple's api
    response = HTTParty.get("http://store.apple.com/us/retail/availabilitySearch?parts.0=#{model}&zip=#{zip}")
    r = JSON::load(response.body)

    r['body']['stores'].each_with_index do |store, i|
      if i < 5 # Check the 5 nearest stores in this ZIP code
        if store['partsAvailability'][model]['pickupDisplay'] == 'available'
          puts "#{model} found in #{store['storeEmail']}"
          return true
        else
          puts "#{model} not found in #{store['storeEmail']}"
        end
      end
    end
    return false
  end

  def txt(model, zip)
    # set up a client to talk to the Twilio REST API
    account_sid = ENV['ACCOUNT_SID']
    auth_token = ENV['AUTH_TOKEN']
    @client = Twilio::REST::Client.new account_sid, auth_token

    @sms = @client.account.messages.create(
      :from => ENV['FROM_PHONE'],
      :to => ENV['TO_PHONE'],
      :body => "#{model} iPhone 5s available near #{zip}"
    )
  end
end

alerter = Alerter.new
zip_codes = ENV['ZIP_CODE'].split(',')

zip_codes.each do |zip_code|
  # black iphone 5s
  alerter.txt("16gb black", zip_code) if alerter.check("ME341LL/A", zip_code)
  alerter.txt("32gb black", zip_code) if alerter.check("ME344LL/A", zip_code)
  alerter.txt("64gb black", zip_code) if alerter.check("ME347LL/A", zip_code)

  # white iphone 5s
  alerter.txt("16gb silver", zip_code) if alerter.check("ME342LL/A", zip_code)
  alerter.txt("32gb silver", zip_code) if alerter.check("ME345LL/A", zip_code)
  alerter.txt("64gb silver", zip_code) if alerter.check("ME348LL/A", zip_code)
end
