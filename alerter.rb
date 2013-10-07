require 'twilio-ruby'
require 'httparty'
require 'json'

class Alerter
  def check(model, zip)
    sleep 1 # be nice to apple's api
    response = HTTParty.get("http://store.apple.com/us/retail/availabilitySearch?parts.0=#{phone}&zip=#{zip}")
    r = JSON::load(response.body)

    r['body']['stores'].each_with_index do |store, i|
      if i < 5 # Check the 5 nearest stores in this ZIP code
        if store['partsAvailability'][phone]['pickupDisplay'] == 'available'
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
seattle = "98122"
# black iphone 5s
alerter.txt("16gb black", seattle) if alerter.check("ME341LL/A", seattle)
alerter.txt("32gb black", seattle) if alerter.check("ME344LL/A", seattle)
alerter.txt("64gb black", seattle) if alerter.check("ME347LL/A", seattle)

# white iphone 5s
alerter.txt("16gb silver", seattle) if alerter.check("ME342LL/A", seattle)
alerter.txt("32gb silver", seattle) if alerter.check("ME345LL/A", seattle)
alerter.txt("64gb silver", seattle) if alerter.check("ME348LL/A", seattle)

# nyc = "10019"
# # black iphone 5s
# alerter.txt("16gb black", nyc) if alerter.check("ME341LL/A", nyc)
# alerter.txt("32gb black", nyc) if alerter.check("ME344LL/A", nyc)
# alerter.txt("64gb black", nyc) if alerter.check("ME347LL/A", nyc)

# # white iphone 5s
# alerter.txt("16gb silver", nyc) if alerter.check("ME342LL/A", nyc)
# alerter.txt("32gb silver", nyc) if alerter.check("ME345LL/A", nyc)
# alerter.txt("64gb silver", nyc) if alerter.check("ME348LL/A", nyc)
