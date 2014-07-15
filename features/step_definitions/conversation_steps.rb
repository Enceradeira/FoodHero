def get_element_and_parameter(id)
  bubble = find_element :xpath, "//*[contains(@name,'#{id}')]"
  text = bubble.name
  _, parameter = text.match(/^#{id}=(.*)$/).to_a
  return bubble, parameter
end

Then(/^FoodHero greets users and asks what they wished to eat$/) do
  bubble, _ = get_element_and_parameter('ConversationBubble-FH:Greeting&FH:OpeningQuestion')
  expect(bubble).not_to be_nil
end

When(/^User wishes to eat British food$/) do
  button('British food').click
end

Then(/^User answers with British food$/) do
  bubble, _ = get_element_and_parameter('ConversationBubble-U:CuisinePreference')
  expect(bubble).not_to be_nil
end

Then(/^FoodHero suggests something for British food$/) do
  bubble, @last_suggestion = get_element_and_parameter('ConversationBubble-FH:Suggestion')
  expect(@last_suggestion).not_to be_nil
  expect(bubble).not_to be_nil
end

Then(/^FoodHero asks if he may get location$/) do
  pending
end

Then(/^FoodHero asks to enable location\-services in settings$/) do
  bubble, _ = get_element_and_parameter('ConversationBubble-FH:BecauseUserDeniedAccessToLocationServices')
  expect(bubble).not_to be_nil
end

When(/^User finds suggestion too expensive$/) do
  button('Too expensive').click
end

Then(/^FoodHero suggests something else for British food$/) do
  bubble, next_suggestion = get_element_and_parameter('ConversationBubble-FH:Suggestion')
  expect(bubble).not_to be_nil
  expect(next_suggestion).not_to be_nil
  expect(next_suggestion).not_to eq(@last_suggestion)
  @last_suggestion = next_suggestion
end