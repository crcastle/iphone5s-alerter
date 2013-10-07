iphone5s-alerter
================

Sends you a text when an iPhone 5s is available in a local Apple store.

Requirements
* Heroku toolbelt and a Heroku account
* Twilio account and outbound number ($1)
* Git

```shell
git clone git@github.com:crcastle/iphone5s-alerter.git
cd iphone5s-alerter
heroku apps:create
git push heroku master
heroku config:add ACCOUNT_SID=<your twilio account sid> AUTH_TOKEN=<your twilio auth token> TO_NUMBER=<your number> FROM_NUMBER=<your twilio from number> ZIP_CODE=<your zip code>
```
Now test it out
```shell
heroku run "ruby alerter.rb"
```
You should see output saying whether a specific model iPhone 5s is available at a store near you.

Now let's schedule that command to run every 10 minutes
```shell
heroku addons:add scheduler:standard
heroku addons:open scheduler
```
In the Heroku scheduler web interface, add the command `ruby alerter.rb` to run every 10 minutes.

A text message will be sent to `TO_NUMBER` from `FROM_NUMBER` using Twilio when an iPhone 5s in black or silver is available near `ZIP_CODE`.
