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

    When I touch map
    Then I see the map

    When I go back to the restaurants-details
    And I go back
    Then I see the conversation view

    When I go to the help view
    Then I see the help view

    When I go back
    Then I see the conversation view

    #When I go to the login view
    #Then I see the login view

    #When I go back
    #Then I see the conversation view

  Scenario: Opening help through link
    Given FoodHero has started and can access location-services
    And FoodHero greets me and suggests something
    And I say nonsense
    And FoodHero says he can't understand me

    When I go to the help view through the link
    Then I see the help view

  Scenario: Sharing to twitter of facebook when suggestion liked
    Given FoodHero has started and can access location-services
    And FoodHero greets me and suggests something
    And I like the restaurant
    And I see my answer "Like"

    When I go to the share view through the link
    Then I see the share view

    When I share on facebook
    Then I see an alert because I can't share in simulator

    When I dismiss alert
    And I share on twitter
    Then I see an alert because I can't share in simulator

    When I dismiss alert
    And I go back
    Then I see the conversation view

    When I go to the share view through the link
    And I see the share view
    And I share on twitter
    And I accept alert
    Then I see the settings