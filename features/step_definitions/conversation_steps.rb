Then(/^FoodHero says "([^"]*)"$/) do |wording|
  expect(text wording).to be_truthy
end