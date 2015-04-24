def last_suggestions
  @last_suggestions ||= []
end

def update_bubbles

end

def get_last_element_and_parameter(id, reverse_position)
  personas = id.match(/(FH:|U:)/).to_a
  if personas.length == 0
    return
  end
  persona = personas.first
  bubbles_of_persona = bubbles.select{|n| n.name.include?(persona) }

  reverse_positions = reverse_position.is_a?(Array) ? reverse_position : [reverse_position]

  puts "--------------- begin dump bubbles| persona:#{persona} id:#{id} reverse_positions:#{reverse_positions.join(',')}|  ------------- "
  bubbles_of_persona.each {|b|
    puts b.name
  }
  puts '--------------- end dump bubbles ----------------------------------------------- '

  result = reverse_positions.map do |pos|
    last_bubble = bubbles_of_persona.reverse.drop(pos).first
    if last_bubble.nil? || !last_bubble.name.include?(id)
        map_result = nil
    else
      _, parameter = last_bubble.name.match(/#{id}\w*=(.*)$/).to_a
      map_result = last_bubble, parameter
    end
    map_result
  end

  result.select{|r| !r.nil? }.first
end

def wait_last_element_and_parameter(id, reverse_position)
  #json = source # this seems to make things more stable ?????
  #puts '---------------- before wait -------------------------------------'
  #puts json

  bubble, parameter = nil
  # :interval=>0.3 triggers find_elements sometimes not to return all elements
  wait_true({:timeout => 30, :interval=>2}) do
    bubble, parameter = get_last_element_and_parameter(id, reverse_position)
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

def help_button
  button('Help')
end

def touch_send
  send_button.click
end

def feedback_entry(entry_name)
  get_last_element_and_parameter("FeedbackEntry=#{entry_name}", 0).select{ |s| s !=nil }
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

def touch_help_entry(method,text)
  help_button.click
  # puts source
  element = find_element(method, text)
  element.click
  touch_send
end

def expect_restaurant_detail_view
  expect(text 'Directions').to be_truthy
end

def expect_fh_suggestion
  bubble, parameter = wait_last_element_and_parameter('FH:Suggestion', [0,1])
  expect(parameter).not_to be_nil
  expect(bubble).not_to be_nil
  last_suggestions << parameter
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

Given(/^FoodHero can access a network$/) do
  send_cheat('C:NO') # find network exception
end

Given(/^FoodHero is very slow in responding$/) do
  send_cheat('C:BS') # be slow
end

Then(/^FoodHero(?: still)? greets me and suggests something$/) do
  bubble, _ = wait_last_element_and_parameter('FH:Greeting', 1)
  expect(bubble).not_to be_nil
  expect_fh_suggestion
end

And(/^FoodHero mentions the occasion$/) do
  bubble, _ = wait_last_element_and_parameter('FH:FirstQuestion', 0)
  expect(bubble).not_to be_nil
  expect_fh_suggestion
end

Then(/^FoodHero asks what I wished to eat$/) do
  bubble, _ = wait_last_element_and_parameter('FH:OpeningQuestion', 0)
  expect(bubble).not_to be_nil
end


Then(/^FoodHero asks me for the occasion$/) do
  bubble, _ = wait_last_element_and_parameter('FH:AskForOccasion', 0)
  expect(bubble).not_to be_nil
end

Then(/^FoodHero asks again what I think about suggestion$/) do
  bubble, _ = wait_last_element_and_parameter('FH:BeforeRepeatingUtteranceAfterError', 0)
  expect(bubble).not_to be_nil
  bubble, _ = wait_last_element_and_parameter('FH:FirstQuestion', 0)
  expect(bubble).not_to be_nil
end

And(/^FoodHero asks what to do next$/) do
  bubble, _ = wait_last_element_and_parameter('FH:WhatToDoNextCommentAfterSuccess', 0)
  expect(bubble).not_to be_nil
end

Then(/^FoodHero asks what to do next after failure$/) do
  bubble, _ = wait_last_element_and_parameter('FH:WhatToDoNextCommentAfterFailure', 0)
  expect(bubble).not_to be_nil
end

Then(/^FoodHero says that nothing was found$/) do
  bubble, _ = wait_last_element_and_parameter('FH:NoRestaurantsFound', 0)
  expect(bubble).not_to be_nil
end

Then(/^FoodHero says he's not connected to the internet$/) do
  bubble, _ = wait_last_element_and_parameter('FH:HasNetworkError', 0)
  expect(bubble).not_to be_nil
end

Then(/^FoodHero says good bye$/) do
  bubble, _ = wait_last_element_and_parameter('FH:GoodBye', 0)
  expect(bubble).not_to be_nil
end

Then(/^FoodHero says he can't understand me$/) do
  bubble, _ = wait_last_element_and_parameter('FH:DidNotUnderstandAndAsksForRepetition', 0)
  expect(bubble).not_to be_nil
end

Then(/^FoodHero(?: still)? suggests something$/) do
  expect_fh_suggestion
end

Then(/^FoodHero asks to enable location\-services in settings$/) do
  bubble, _ = wait_last_element_and_parameter('FH:BecauseUserDeniedAccessToLocationServices', 0)
  expect(bubble).not_to be_nil
end

Then(/^FoodHero suggests something else$/) do
  # wait until next suggestion appears
  bubble, next_suggestion = wait_last_element_and_parameter('FH:Suggestion', [0,1]) {
      |p| !last_suggestions.include?(p)
  }

  expect(bubble).not_to be_nil
  expect(next_suggestion).not_to be_nil
  expect(last_suggestions).not_to include(next_suggestion)
  last_suggestions << next_suggestion
end

When(/^I go to the restaurants\-details for the last suggested restaurant$/) do
  link = find_element(:xpath, "//*[contains(@name,'FH:Suggestion')]//UIALink")
  expect(link).not_to be_nil
  link.click
end

When(/^I go to the help view through the link$/) do
  link = find_element(:xpath, "//*[contains(@name,'FH:DidNotUnderstandAndAsksForRepetition')]//UIALink")
  expect(link).not_to be_nil
  link.click
end

Then(/^I see my answer with "([^"]*)" food$/) do |cuisines_as_string|
  bubble, parameter = wait_last_element_and_parameter('U:CuisinePreference', 0) { |p| p.eql? cuisines_as_string }
  expect(bubble).not_to be_nil
  expect(parameter).to eq(cuisines_as_string)
end

Then(/^I see my answer "([^"]*)"$/) do |answer|
  bubble, parameter = wait_last_element_and_parameter('U:SuggestionFeedback', 0) { |p| p.eql? answer }
  expect(parameter).to eq(answer)
  expect(bubble).not_to be_nil
end

Then(/^I see my answer DislikesKindOfFood$/) do
  bubble, _ = wait_last_element_and_parameter('U:DislikesKindOfFood', 0)
  expect(bubble).not_to be_nil
end

Then(/^I answer with I fixed the problem, please try again$/) do
  bubble, _ = wait_last_element_and_parameter('U:TryAgainNow', 0)
  expect(bubble).not_to be_nil
end

When(/^I touch send without entering anything$/) do
  touch_send
end

When(/^I dislike the occasion$/) do
  text = 't want to have'
  # search by xpath because occasion is dynamic
  touch_help_entry  :xpath, "//UIAStaticText[contains(@name,'#{text}')]"
end


When(/^I dislike the kind of food$/) do
  touch_help_entry :name, "I don't like this kind of food"
end

When(/^I want to have some drinks$/) do
  touch_help_entry :name, 'I want to have Lunch'
end

When(/^I don't like the restaurant$/) do
  touch_help_entry :name, "I don't like it"
end

When(/^I don't like the restaurant by typing it$/) do
  text_field.send_keys('I dont like it')
  touch_send
end

When(/^I find the restaurant too far away$/) do
  touch_help_entry :name, "It's too far away"
end

When(/^I find the restaurant too far away using help$/) do
  touch_help_entry(:name, "It's too far away")
end

When(/^I find the restaurant looks too cheap$/) do
  touch_help_entry :name, 'It looks too cheap'
end

When(/^I find the restaurant looks too expensive$/) do
  touch_help_entry :name, "It's too expensive"
end

When(/^I like the restaurant$/) do
  touch_help_entry :name, 'I like it'
end

When(/^I say try again$/) do
  touch_help_entry :name, 'Try again'
end

When(/^I want FoodHero to abort search$/) do
  touch_help_entry :name, 'Forget about it'
end

When(/^I want to search for another restaurant$/) do
  touch_help_entry :name, 'Search for another restaurant'
end

When(/^I say that problem with location\-service has been fixed$/) do
    touch_help_entry :name, 'Try again'
end

When(/^I want FoodHero to start over again$/) do
  touch_help_entry :name, 'Start again'
end

When(/^I say nonsense$/) do
  text_field.send_keys('¨')
  touch_send
end

When(/^I wish to eat "Sushi"/) do
  touch_help_entry :name, "I'd rather have Sushi"
end

When(/^I say good bye$/) do
  touch_help_entry :name, 'Good Bye'
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
  # bubble, _ = wait_last_element_and_parameter('FH:Suggestion') { |_| true }
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
  bubble, _ = wait_last_element_and_parameter('FH:Suggestion', [0,1]) { |_| true }
  expect(bubble.displayed?).to be_truthy
end

Then(/^FoodHero displays Semantic\-ID "([^"]*)" in last suggestion/) do |semanticId|
  bubble, _ = wait_last_element_and_parameter('FH:Suggestion', [0,1]) { |_| true }
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

And(/^I (can|can't) touch help/) do |option|
  condition = option == "can't" ? be_falsey: be_truthy
  expect(help_button.enabled?).to condition
end

When(/^I touch the text field$/) do
  touch_text_field
end

Then(/^I touch the review summary$/) do
  review_summary.click
end

Then(/^I see the restaurant\-details for the last suggested restaurant$/) do

  directions = nil
  wait_true({:timeout => 30, :interval=>0.3}) do
    directions = find_elements(:xpath,"//UIAStaticText[contains(@name,'miles away') or contains(@name,'yards away')]")
    directions.count > 0
  end

  # directions
  expect(directions.count).to be(1)
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


