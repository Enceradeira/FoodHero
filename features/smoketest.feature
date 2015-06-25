Feature: App runs correctly in production

Scenario: Privacy-Policy can be read
  Given I visit online "http://foodheroweb.herokuapp.com/legal/privacy_policy"
  Then I read online "We are committed to protected the privacy of “Food Hero”’s users"