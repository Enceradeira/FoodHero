def click_me_button
  button 'click me!'
end

Given(/^I start the Hello\-World app$/) do
  expect(click_me_button).to be_truthy
end

When(/^I click the button$/) do
  click_me_button.click
end

Then(/^the app says 'Hello World'$/) do
  expect(text 'Hello World').to be_truthy
end