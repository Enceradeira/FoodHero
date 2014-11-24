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
  wait_true({:timeout => 30, :interval=>0.3}) do
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

def review_summary
  find_element(:name, 'ReviewSummary')
end

def button_restaurant
  button('Restaurant')
end

def touch_text_field
  text_field.click
end

def click_text_and_send_feedback(entry_name)
  touch_text_field
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

def microphone_button
  find_element(:name, 'microphone')
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

Then(/^I see my answer "([^"]*)"$/) do |answer|
  bubble, parameter = wait_last_element_and_parameter('ConversationBubble-U:SuggestionFeedback') { |p| p.eql? answer }
  expect(parameter).to eq(answer)
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
  text_field.send_keys('I dont like that restaurant')
  touch_send
end

When(/^I find the restaurant too far away$/) do
  text_field.send_keys  ('Its too far away')
  touch_send
end

When(/^I find the restaurant looks too cheap$/) do
  text_field.send_keys('It looks too cheap')
  touch_send
end

When(/^I find the restaurant looks too expensive$/) do
  text_field.send_keys('It looks too expensive')
  touch_send
end

When(/^I like the restaurant$/) do
  text_field.send_keys('I like it')
  touch_send
end

When(/^I choose something from the input list$/) do
  touch_text_field
  feedback_entry('I like it')[0].click
end

When(/^I say try again$/) do
  text_field.send_keys('Please, try again')
  touch_send
end

When(/^I want FoodHero to abort search$/) do
  text_field.send_keys('Just forget about it!')
  touch_send
end

When(/^I want to search for another restaurant$/) do
  text_field.send_keys('Search again, please!')
  touch_send
end

When(/^I say that problem with location\-service has been fixed$/) do
    text_field.send_keys("It's fixed now")
    touch_send
end

When(/^I wish to eat "([^"]*)" food by typing it$/) do |cuisines_as_string|
  text_field.send_keys "I want to eat #{cuisines_as_string} food"

  touch_send
end

When(/^I say good bye$/) do
  text_field.send_keys 'No thanks! Good bye'

  touch_send
end

When(/^I touch input list button$/) do
  microphone_button.click
end

When(/^I tough today's opening hours$/) do
  label = find_element(:name, "today's opening hours")
  label.click
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

When(/^I go back to the restaurants\-details$/) do
  button_restaurant.click
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

Then(/^I (can|can't) touch the microphone button$/) do |option|
  condition = option == "can't" ? be_falsey: be_truthy
  expect(microphone_button.enabled?).to condition
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

Then(/^I touch the review summary$/) do
  review_summary.click
end

Then(/^I see the restaurant\-details for the last suggested restaurant$/) do
  # directions
  directions = find_elements(:xpath,"//UIAStaticText[contains(@name,'miles away') or contains(@name,'yards away')]")
  expect(directions.count).to be(1)
  # wait_true { text 'Directions' }
  # restaurant name
  restaurant = last_suggestions.last
  restaurant_name = restaurant.split(', ').first

  # handle a anomaly that sometimes occurs at our test-location 'Apple'
  if restaurant_name == 'Saint Michaels Alley'
    restaurant_name = "Saint Michael's Alley"
  end

  expect(text restaurant_name).to be_truthy
end

Then(/^I see the week's opening hours$/) do
  daily_opening_hours = find_elements(:xpath,"//*[contains(@name,'opening hour of that day')]")
  expect(daily_opening_hours.count).to be(7)
end

Then(/^I see the review summary$/) do
  expect(review_summary).not_to be_nil
end

Then(/^I see the review summary enlarged$/) do
  expect(review_summary).not_to be_nil
  expect(button_restaurant).not_to be_nil # in addition to the review-summary on the enlarged view is also a back button
end

Then(/^I see a review comment$/) do
  review_summary = find_element(:name, 'ReviewComment')
  expect(review_summary).not_to be_nil
end

When(/^I dismiss the week's opening hours$/) do
  # tap somewhere outside the opening hours
  execute_script 'mobile: tap', :x => 50, :y => 50
end

=begin
When(/^I navigate to next review page$/) do
  execute_script 'mobile: swipe', :startX => 0.6, :startY => 0.75, :endX => 0.4, :endY => 0.75, :duration=>0.5
end
=end
