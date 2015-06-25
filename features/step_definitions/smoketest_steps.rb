require 'net/http'

Given(/^I visit online "(.*)"$/) do |url|
  url = URI.parse(url)
  req = Net::HTTP::Get.new(url.to_s)
  res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
  }
  @online_body = res.body.force_encoding('UTF-8')
end

Then(/^I read online "([^"]*)"$/) do |text|
  expect(@online_body).to include(text)
end

