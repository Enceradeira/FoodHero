def last_suggestions
  @last_suggestions ||= []
end

def get_last_element_and_parameter(id)
  bubble = (find_elements :xpath, "//*[contains(@name,'#{id}')]").last
  if bubble.nil?
    return nil
  end
  text = bubble.name
  _, parameter = text.match(/^#{id}\w*=(.*)$/).to_a
  return bubble, parameter
end

def wait_last_element_and_parameter(id)
  bubble, parameter = nil
  wait_true(30, 0.30) do
    bubble, parameter = get_last_element_and_parameter(id)
    if block_given?
      block_test = parameter != nil && yield(parameter)
    else
      block_test = true
    end
    bubble != nil && block_test
  end
  return bubble, parameter
end

def split_at_comma(cuisines_as_string)
  cuisines_as_string.split(',').map { |s| s.strip }.select { |s| s != '' }
end

def click_send
  find_element(:name, 'send cuisine').click
end

def feedback_entry(entry_name)
  get_last_element_and_parameter("FeedbackEntry=#{entry_name}").select{ |s| s !=nil }
end

def click_feedback_entry_and_send(entry_name)
  feedback_entry(entry_name)[0].click
  click_send
end

def text_field
  find_element(:name, 'cuisine text')
end

def click_text_field
  text_field.click
end

def click_text_and_send_feedback(entry_name)
  click_text_field
  click_feedback_entry_and_send(entry_name)
end

def click_list_and_send_feedback(entry_name)
  show_list_button.click
  click_feedback_entry_and_send(entry_name)
end

def send_cheat(command)
  text_field.send_keys command
  click_send
end

def show_list_button
  find_element(:name, 'show cuisine list')
end

Given(/^FoodHero will not find any restaurants$/) do
  send_cheat('C:FN') # find nothing
end

When(/^FoodHero will find restaurants$/) do
  send_cheat('C:FS') # find something
end

Given(/^FoodHero can't access a network$/) do
  send_cheat('C:NE') # find network exception
end

Then(/^FoodHero(?: still)? greets me and asks what I wished to eat$/) do
  bubble, _ = wait_last_element_and_parameter('ConversationBubble-FH:Greeting&FH:OpeningQuestion')
  expect(bubble).not_to be_nil
end

Then(/^FoodHero asks what I wished to eat$/) do
  bubble, _ = wait_last_element_and_parameter('FH:OpeningQuestion')
  expect(bubble).not_to be_nil
end

And(/^FoodHero asks what to do next$/) do
  bubble, _ = get_last_element_and_parameter('ConversationBubble-FH:WhatToDoNext')
  expect(bubble).not_to be_nil
end


Then(/^FoodHero says that nothing was found$/) do
  bubble, _ = get_last_element_and_parameter('ConversationBubble-FH:NoRestaurantsFound')
  expect(bubble).not_to be_nil
end

Then(/^FoodHero says good bye$/) do
  bubble, _ = get_last_element_and_parameter('ConversationBubble-FH:GoodBye')
  expect(bubble).not_to be_nil
end

Then(/^FoodHero(?: still)? suggests something for "([^"]*)" food$/) do |cuisines_as_string|
  bubble, parameter = wait_last_element_and_parameter('ConversationBubble-FH:Suggestion')
  expect(parameter).not_to be_nil
  expect(bubble).not_to be_nil
  last_suggestions << parameter
end

Then(/^FoodHero asks to enable location\-services in settings$/) do
  bubble, _ = wait_last_element_and_parameter('ConversationBubble-FH:BecauseUserDeniedAccessToLocationServices')
  expect(bubble).not_to be_nil
end

Then(/^FoodHero suggests something else for "([^"]*)" food$/) do |cuisines_as_string|
  # wait until next suggestion appears
  bubble, next_suggestion = wait_last_element_and_parameter('ConversationBubble-FH:Suggestion') { |p| !last_suggestions.include?(p) }

  expect(bubble).not_to be_nil
  expect(next_suggestion).not_to be_nil
  expect(last_suggestions).not_to include(next_suggestion)
  last_suggestions << next_suggestion
end

Then(/^I answer with "([^"]*)" food$/) do |cuisines_as_string|
  bubble, parameter = wait_last_element_and_parameter('ConversationBubble-U:CuisinePreference') { |p| p.eql? cuisines_as_string }
  expect(bubble).not_to be_nil
  expect(parameter).to eq(cuisines_as_string)
end

Then(/^I answer with "([^"]*)"$/) do |answer|
  sanitized_answer = answer.tr("'", '')
  bubble, parameter = wait_last_element_and_parameter('ConversationBubble-U:SuggestionFeedback') { |p| p.eql? sanitized_answer }
  expect(parameter).to eq(sanitized_answer)
  expect(bubble).not_to be_nil
end

Then(/^I answer with I fixed the problem, please try again$/) do
  bubble, _ = wait_last_element_and_parameter('ConversationBubble-U:DidResolveProblemWithAccessLocationService')
  expect(bubble).not_to be_nil
end

When(/^I touch send without entering anything$/) do
  click_send
end

When(/^I don't like the restaurant$/) do
  click_text_and_send_feedback('I dont like that restaurant')
end

When(/^I find the restaurant too far away$/) do
  click_list_and_send_feedback('Its too far away')
end

When(/^I find the restaurant looks too cheap$/) do
  click_text_and_send_feedback('It looks too cheap')
end

When(/^I find the restaurant looks too expensive$/) do
  click_list_and_send_feedback('It looks too expensive')
end

When(/^I like the restaurant$/) do
  click_text_and_send_feedback('I like it')
end

When(/^I say try again$/) do
  show_list_button.click
  get_last_element_and_parameter('TryAgainEntry')[0].click
  click_send
end

When(/^I want to search for another restaurant$/) do
  show_list_button.click
  get_last_element_and_parameter('SearchForAnotherRestaurantEntry')[0].click
  click_send
end

When(/^I say that problem with location\-service has been fixed$/) do
  click_text_field
  get_last_element_and_parameter('DidResolveProblemWithAccessLocationServiceEntry')[0].click
  click_send
end

When(/^I wish to eat "([^"]*)" food by typing it$/) do |cuisines_as_string|
  text_field.send_keys cuisines_as_string

  click_send
end

When(/^I wish to eat "([^"]*)" food by choosing it$/) do |cuisines_as_string|
  show_list_button.click
  split_at_comma(cuisines_as_string).each do |cuisine|
    get_last_element_and_parameter("CuisineEntry=#{cuisine}")[0].click
  end
  click_send
end

When(/^I say good bye$/) do
  click_text_field
  get_last_element_and_parameter('GoodByeEntry')[0].click
  click_send
end


When(/^I touch input list button$/) do
  show_list_button.click
end

Then(/^I can see the feedback list$/) do
  entry = feedback_entry('I like it')[0]
  expect(entry.displayed?).to be_truthy
end

And(/^I touch a conversation bubble$/) do
  # wait until next suggestion appears
  bubble, _ = wait_last_element_and_parameter('ConversationBubble-FH:Suggestion') { |_| true }
  bubble.click
end

Then(/^I can't see the feedback list$/) do
  entry = feedback_entry('I like it')[0]
  expect(entry.displayed?).to be_falsey
end

Then(/^I can see last suggestion$/) do
  bubble, _ = wait_last_element_and_parameter('ConversationBubble-FH:Suggestion') { |_| true }
  expect(bubble.displayed?).to be_truthy
end
