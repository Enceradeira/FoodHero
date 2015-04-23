Feature: Navigation in app

  Scenario: I start Food Hero and explore app
    Given FoodHero has started and can access location-services
    Then FoodHero greets me and suggests something

    When I go to the restaurants-details for the last suggested restaurant
    Then I see the restaurant-details for the last suggested restaurant
    When I tough today's opening hours
    Then I see the week's opening hours

    When I dismiss the week's opening hours
    Then I see the review summary

    Then I touch the review summary
    Then I see the review summary enlarged

    When I go back to the restaurants-details
    Then I see the review summary

    When I go back
    Then I see the conversation view

    When I go to the help view
    Then I see the help view

    When I go back
    Then I see the conversation view

    When I go to the login view
    Then I see the login view

    When I go back
    Then I see the conversation view


