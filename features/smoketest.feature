@smoke_test
Feature: App runs correctly in production

  Scenario: Privacy-Policy can be read
    Then "http://foodheroweb.herokuapp.com/legal/privacy_policy" returns a html-body

  Scenario: FH-Places-API can be read
    Then "http://foodheroweb.herokuapp.com/api/v1/places?cuisine=Indian%20Food&occasion=lunch&location=51.500152,-0.126236" returns json-data
