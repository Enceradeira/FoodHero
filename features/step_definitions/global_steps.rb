def expect_conversation_view
  expect(button 'British or Indian food').not_to be_nil
end

def expect_map_view
  expect(text 'Map is under construction').to be_truthy
end

def expect_login_view
  expect(text 'Login is under construction').to be_truthy
end

Given(/^FoodHero has started$/) do
  expect_conversation_view
end

When(/^I go to the map view$/) do
  button('Map').click
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

Then(/^I see the map view$/) do
  expect_map_view
end

Then(/^I see the login view$/) do
  expect_login_view
end

