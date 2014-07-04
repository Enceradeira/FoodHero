Then(/^FoodHero greets users and asks what they wished to eat$/) do
  greeting_bubble = find_element :accessibility_id, 'ConversationBubble-Greeting&OpeningQuestion'
  expect(greeting_bubble).not_to be_nil
end