Then(/^FoodHero greets users and asks what they wished to eat$/) do
  greeting_bubble = find_element :accessibility_id, 'ConversationBubble-Greeting&OpeningQuestion'
  expect(greeting_bubble).not_to be_nil
end

When(/^User wishes to eat British or Indian food$/) do
  button('British or Indian food').click
end

Then(/^User answers with British or Indian food$/) do
  greeting_bubble = find_element :accessibility_id, 'ConversationBubble-UserAnswer:British or Indian food'
  expect(greeting_bubble).not_to be_nil
end