@smoke_test
Feature: App runs correctly in production

  Scenario: Privacy-Policy can be read
    Then "http://foodheroweb.herokuapp.com/legal/privacy_policy" returns in html-body "We are committed to protecting the privacy of “Food Hero”’s users"

  Scenario: FH-Places-API can be read
    Then "http://foodheroweb.herokuapp.com/api/v1/places?cuisine=Indian%20Food&occasion=lunch&location=51.500152,-0.126236" returns json-data

  Scenario: Product-Website can be read
    Then "http://www.thefoodhero.com" returns in html-body "Important Note About This Website's SEO"