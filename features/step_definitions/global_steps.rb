
def allow_access_to_location_services
  alert_accept
end

def expect_alert_location_services
  expect(text 'Location is required to search for restaurants close to where you are.').to be_truthy
end

def expect_conversation_view
  expect(button 'Send').not_to be_nil
end

def expect_help_view
  expect(text 'You can say or type something like').to be_truthy
end

def expect_login_view
  expect(text 'Login is under construction').to be_truthy
end

Given(/^FoodHero has started and can access location\-services$/) do
  expect_alert_location_services
  allow_access_to_location_services
  expect_conversation_view
end

When(/^I go to the help view$/) do
  button('Help').click
end

When(/^I go back$/) do
  button('Food Hero').click
end

When(/^I go to the login view$/) do
  button('Login').click
end

Then(/^I see the conversation view$/) do
  expect_conversation_view
end

Then(/^I see the help view$/) do
  expect_help_view
end

Then(/^I see the login view$/) do
  expect_login_view
end

Then(/^FoodHero asks for access to the location\-services$/) do
  expect_alert_location_services
end

When(/^I allow access to the location\-services$/) do
  allow_access_to_location_services
end

When(/^I don't allow access to the location\-services$/) do
  alert_dismiss
end