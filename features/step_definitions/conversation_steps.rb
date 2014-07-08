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

Then(/^FoodHero suggests 'King Head, Norwich'$/) do
  greeting_bubble = find_element :accessibility_id, "ConversationBubble-Suggestion:King's Head, Norwich"
  expect(greeting_bubble).not_to be_nil
end