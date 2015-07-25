require 'net/http'

Then(/^"(.*)" returns a html-body$/) do |url|
  url = URI.parse(url)
  req = Net::HTTP::Get.new(url.to_s)
  res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
  }
  online_body = res.body.force_encoding('UTF-8')
  expect(online_body).to include("We are committed to protected the privacy of “Food Hero”’s users")
end

Then(/^"(.*)" returns json-data$/) do |url|
  url = URI.parse(url)
  req = Net::HTTP::Get.new(url.to_s)
  res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
  }
  body = res.body.force_encoding('UTF-8')
  json = JSON.parse(body)

  expect(json).not_to be_empty
  first_element = json[0]
  expect(first_element.keys).to include('placeId')
end