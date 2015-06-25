
def allow_access_to_location_services
  alert_accept
end

def expect_alert_location_services
  expect(text 'Location is required to search for restaurants close to where you are.').to be_truthy
end

def expect_data_collection_alert
  expect(text 'Allow “Food Hero” to collect anonymous data to improve future versions?').to be_truthy
end

def allow_data_collection
  alert_accept
end

def expect_conversation_view
  expect(button 'Send').not_to be_nil
end

def expect_help_view
  wait_true({:timeout => 30, :interval=>2}) do
    text 'You can say or type something like'
  end
  # expect(text 'You can say or type something like').to be_truthy
end

def expect_share_view
  wait_true({:timeout => 30, :interval=>2}) do
    text 'Food Hero is cool'
  end
end

def expect_login_view
  expect(text 'Login is under construction').to be_truthy
end

Given(/^FoodHero has started and I accept alerts$/) do
  expect_and_answer_data_collection_alert
  expect_alert_location_services
  allow_access_to_location_services
  expect_conversation_view
end


def expect_and_answer_data_collection_alert
  expect_data_collection_alert
  allow_data_collection
end

Given(/^I have answered the data collection alert$/) do
  expect_and_answer_data_collection_alert
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

Then(/^I see the share view$/) do
  expect_share_view
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

When(/^I dismiss alert$/) do
  alert_dismiss
end

When(/^I accept alert$/) do
  alert_accept
end
