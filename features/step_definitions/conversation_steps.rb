Then(/^FoodHero greets users and asks what they wished to eat$/) do
  greeting_bubble = find_element :accessibility_id, 'ConversationBubble-Greeting&OpeningQuestion'
  expect(greeting_bubble).not_to be_nil
end

When(/^User wishes to eat British food$/) do
  button('British food').click
end

Then(/^User answers with British food$/) do
  greeting_bubble = find_element :accessibility_id, 'ConversationBubble-UserAnswer:British food'
  expect(greeting_bubble).not_to be_nil
end

Then(/^FoodHero suggests something for British food$/) do
  bubble = find_element :accessibility_id, "ConversationBubble-Suggestion:British food"
  expect(bubble).not_to be_nil
end

Then(/^FoodHero asks if he may get location$/) do
  pending
end