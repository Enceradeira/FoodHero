def get_last_element_and_parameter(id)
  bubble = (find_elements :xpath, "//*[contains(@name,'#{id}')]").last
  if bubble.nil?
    return nil
  end
  text = bubble.name
  _, parameter = text.match(/^#{id}\w*=(.*)$/).to_a
  return bubble, parameter
end

def split_at_comma(cuisines_as_string)
  cuisines_as_string.split(',').map { |s| s.strip }.select { |s| s != '' }
end

def click_send
  find_element(:name, 'send cuisine').click
end


Then(/^FoodHero greets users and asks what they wished to eat$/) do
  bubble, _ = get_last_element_and_parameter('ConversationBubble-FH:Greeting&FH:OpeningQuestion')
  expect(bubble).not_to be_nil
end

Then(/^User answers with "([^"]*)" food$/) do |cuisines_as_string|
  bubble, parameter = get_last_element_and_parameter('ConversationBubble-U:CuisinePreference')
  expect(bubble).not_to be_nil
  expect(parameter).to eq(cuisines_as_string)
end

Then(/^FoodHero suggests something for "([^"]*)" food$/) do |cuisines_as_string|
  bubble, @last_suggestion = get_last_element_and_parameter('ConversationBubble-FH:Suggestion')
  expect(@last_suggestion).not_to be_nil
  expect(bubble).not_to be_nil
end

Then(/^FoodHero asks to enable location\-services in settings$/) do
  bubble, _ = get_last_element_and_parameter('ConversationBubble-FH:BecauseUserDeniedAccessToLocationServices')
  expect(bubble).not_to be_nil
end

When(/^User doesn't like that restaurant$/) do
  find_element(:name, 'cuisine text').click
  get_last_element_and_parameter('FeedbackEntry=I dont like that restaurant')[0].click
  click_send
end

Then(/^FoodHero suggests something else for "([^"]*)" food$/) do |cuisines_as_string|
  bubble, next_suggestion = get_last_element_and_parameter('ConversationBubble-FH:Suggestion')
  expect(bubble).not_to be_nil
  expect(next_suggestion).not_to be_nil
  expect(next_suggestion).not_to eq(@last_suggestion)
  @last_suggestion = next_suggestion
end

When(/^User wishes to eat "([^"]*)" food by typing it$/) do |cuisines_as_string|
  cuisine_text = find_element :name, 'cuisine text'
  cuisine_text.send_keys cuisines_as_string

  click_send
end


When(/^User wishes to eat "([^"]*)" food by choosing it$/) do |cuisines_as_string|
  find_element(:name, 'show cuisine list').click
  split_at_comma(cuisines_as_string).each do |cuisine|
    get_last_element_and_parameter("CuisineEntry=#{cuisine}")[0].click
  end
  click_send
end