Feature: Navigation in app

  Scenario: User starts Food Hero and explores app
    Given FoodHero has started
    Then I see the conversation view
    When I go to the map view
    Then I see the map view
    When I go back
    Then I see the conversation view
    When I go to the login view
    Then I see the login view
    When I go back
    Then I see the conversation view


