Feature: Hello-World app

  Scenario: User clicks on button and app says 'Hello World'
    Given I start the Hello-World app
    When I click the button
    Then the app says 'Hello World'