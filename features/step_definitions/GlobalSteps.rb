=begin
def click_me_button
  button 'click me!'
end

Given(/^I start the Hello\-World app$/) do
  expect(click_me_button).to be_truthy
end

When(/^I click the button$/) do
  click_me_button.click
end

Then(/^the app says 'Hello World'$/) do
  expect(text 'Hello World').to be_truthy
end
=end

def expect_conversation_view
  expect(text 'Conversation is under construction').to be_truthy
end

Then(/^I see the conversation view$/) do
  expect_conversation_view
end


Given(/^FoodHero has started$/) do
  expect_conversation_view
end