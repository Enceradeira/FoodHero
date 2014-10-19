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
  #json = source # this seems to make things more stable ?????
  #puts '---------------- before wait -------------------------------------'
  #puts json

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

  #json = source # this seems to make things more stable ?????
  #puts '---------------- after wait -------------------------------------'
  #puts json

  return bubble, parameter
end

def split_at_comma(cuisines_as_string)
  cuisines_as_string.split(',').map { |s| s.strip }.select { |s| s != '' }
end

def send_button
  find_element(:name, 'send cuisine')
end

def touch_send
  send_button.click
end

def feedback_entry(entry_name)
  get_last_element_and_parameter("FeedbackEntry=#{entry_name}").select{ |s| s !=nil }
end

def click_feedback_entry_and_send(entry_name)
  feedback_entry(entry_name)[0].click
  touch_send
end

def text_field
  find_element(:name, 'cuisine text')
end

def cheat_text_field
  find_element(:name, 'cheat text')
end

def touch_text_field
  text_field.click
end

def click_text_and_send_feedback(entry_name)
  touch_text_field
  click_feedback_entry_and_send(entry_name)
end

def click_list_and_send_feedback(entry_name)
  show_list_button.click
  click_feedback_entry_and_send(entry_name)
end

def send_cheat(command)
  unless @cheat_enabled
    text_field.send_keys 'C:E' # enable cheating
    touch_send
    @cheat_enabled = true
  end

  cheat_text_field.send_keys command,:return
end

def show_list_button
  find_element(:name, 'show cuisine list')
end

def expect_restaurant_detail_view
  expect(text 'Directions').to be_truthy
end

Given(/^FoodHero will not find any restaurants$/) do
  send_cheat('C:FN') # find nothing
end

Given(/^I configure FoodHero to show Semantic\-Ids$/) do
  send_cheat('C:SS') # show semantic-Id
end

When(/^FoodHero will find restaurants$/) do
  send_cheat('C:FS') # find something
end

Given(/^FoodHero can't access a network$/) do
  send_cheat('C:NE') # find network exception
end


Given(/^FoodHero is very slow in responding$/) do
  send_cheat('C:BS') # be slow
end

Then(/^FoodHero(?: still)? greets me and asks what I wished to eat$/) do
  bubble, _ = wait_last_element_and_parameter('ConversationBubble-FH:Greeting')
  expect(bubble).not_to be_nil
  bubble, _ = wait_last_element_and_parameter('ConversationBubble-FH:OpeningQuestion')
  expect(bubble).not_to be_nil
end

Then(/^FoodHero asks what I wished to eat$/) do
  bubble, _ = wait_last_element_and_parameter('FH:OpeningQuestion')
  expect(bubble).not_to be_nil
end

And(/^FoodHero asks what to do next$/) do
  bubble, _ = get_last_element_and_parameter('ConversationBubble-FH:WhatToDoNextCommentAfterSuccess')
  expect(bubble).not_to be_nil
end

Then(/^FoodHero asks what to do next after failure$/) do
  bubble, _ = get_last_element_and_parameter('ConversationBubble-FH:WhatToDoNextCommentAfterFailure')
  expect(bubble).not_to be_nil
end

Then(/^FoodHero says that nothing was found$/) do
sleep 10
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

When(/^I go to the restaurants\-details for the last suggested restaurant$/) do
  link = find_element(:xpath, "//*[contains(@name,'ConversationBubble-FH:Suggestion')]//UIALink")
  expect(link).not_to be_nil
  link.click
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
  touch_send
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

When(/^I choose something from the input list$/) do
  touch_text_field
  feedback_entry('I like it')[0].click
end

When(/^I say try again$/) do
  show_list_button.click
  get_last_element_and_parameter('TryAgainEntry')[0].click
  touch_send
end

When(/^I want FoodHero to abort search$/) do
  show_list_button.click
  get_last_element_and_parameter('AbortEntry')[0].click
  touch_send
end

When(/^I want to search for another restaurant$/) do
  show_list_button.click
  get_last_element_and_parameter('SearchForAnotherRestaurantEntry')[0].click
  touch_send
end

When(/^I say that problem with location\-service has been fixed$/) do
  touch_text_field
  get_last_element_and_parameter('DidResolveProblemWithAccessLocationServiceEntry')[0].click
  touch_send
end

When(/^I wish to eat "([^"]*)" food by typing it$/) do |cuisines_as_string|
  text_field.send_keys cuisines_as_string

  touch_send
end

When(/^I wish to eat "([^"]*)" food by choosing it$/) do |cuisines_as_string|
  show_list_button.click
  split_at_comma(cuisines_as_string).each do |cuisine|
    get_last_element_and_parameter("CuisineEntry=#{cuisine}")[0].click
  end
  touch_send
end

When(/^I say good bye$/) do
  touch_text_field
  get_last_element_and_parameter('GoodByeEntry')[0].click
  touch_send
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
  # bubble, _ = wait_last_element_and_parameter('ConversationBubble-FH:Suggestion') { |_| true }
  bubble = find_element(:xpath, '//UIATableCell/UIAWebView/UIAStaticText')
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

Then(/^FoodHero displays Semantic\-ID "([^"]*)" in last suggestion/) do |semanticId|
  bubble, _ = wait_last_element_and_parameter('ConversationBubble-FH:Suggestion') { |_| true }
  expect(bubble.label).to include(semanticId)
end

Then(/^I (can|can't) touch input list button$/) do |option|
  condition = option == "can't" ? be_falsey: be_truthy
  expect(show_list_button.enabled?).to condition
end

And(/^I (can|can't) enter text$/) do |option|
  condition = option == "can't" ? be_falsey: be_truthy
  expect(text_field.enabled?).to condition
end

And(/^I (can|can't) touch send$/) do |option|
  condition = option == "can't" ? be_falsey: be_truthy
  expect(send_button.enabled?).to condition
end


When(/^I touch the text field$/) do
  touch_text_field
end

Then(/^I see the restaurant\-details for the last suggested restaurant$/) do
  wait_true { text 'Directions' }
  restaurant = last_suggestions.last
  restaurant_name = restaurant.split(', ').first
  expect(text restaurant_name).to be_truthy
end