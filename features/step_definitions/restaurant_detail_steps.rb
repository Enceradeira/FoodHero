def expect_restaurant_detail_view
  expect(text 'Directions').to be_truthy
end

Then(/^I see the restaurant\-details for the last suggested restaurant$/) do
  expect_restaurant_detail_view
end