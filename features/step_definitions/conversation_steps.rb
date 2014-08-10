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

def split_at_comma(cuisines_as_string)
  cuisines_as_string.split(',').map { |s| s.strip }.select { |s| s != '' }
end

def click_send
  find_element(:name, 'send cuisine').click
end

def click_feedback_entry_and_send(entry_name)
  get_last_element_and_parameter("FeedbackEntry=#{entry_name}")[0].click
  click_send
end

def click_text_and_send_feedback(entry_name)
  find_element(:name, 'cuisine text').click
  click_feedback_entry_and_send(entry_name)
end

def click_list_and_send_feedback(entry_name)
  find_element(:name, 'show cuisine list').click
  click_feedback_entry_and_send(entry_name)
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
  bubble, parameter = get_last_element_and_parameter('ConversationBubble-FH:Suggestion')
  expect(parameter).not_to be_nil
  expect(bubble).not_to be_nil
  last_suggestions << parameter
end

Then(/^User answers with "([^"]*)"$/) do |answer|
  bubble, parameter = get_last_element_and_parameter('ConversationBubble-U:SuggestionFeedback')
  expect(parameter).to eq(answer.tr("'",''))
  expect(bubble).not_to be_nil
end

Then(/^FoodHero asks to enable location\-services in settings$/) do
  bubble, _ = get_last_element_and_parameter('ConversationBubble-FH:BecauseUserDeniedAccessToLocationServices')
  expect(bubble).not_to be_nil
end

When(/^User doesn't like that restaurant$/) do
  click_text_and_send_feedback('I dont like that restaurant')
end

When(/^User finds restaurant too far away$/) do
  click_list_and_send_feedback('Its too far away')
end

When(/^User finds restaurant looks too cheap$/) do
  click_text_and_send_feedback('It looks too cheap')
end

When(/^User finds restaurant looks too expensive$/) do
  click_list_and_send_feedback('It looks too expensive')
end

When(/^User likes the restaurant$/) do
  click_text_and_send_feedback('I like it')
end

Then(/^FoodHero suggests something else for "([^"]*)" food$/) do |cuisines_as_string|
  bubble, next_suggestion = get_last_element_and_parameter('ConversationBubble-FH:Suggestion')
  expect(bubble).not_to be_nil
  expect(next_suggestion).not_to be_nil
  expect(last_suggestions).not_to include(next_suggestion)
  last_suggestions << next_suggestion
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

