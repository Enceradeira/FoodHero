@app
Feature: Navigation in app

  Scenario: I start Food Hero and explore app
    Given FoodHero has started and I accept alerts
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
    Given FoodHero has started and I accept alerts
    And FoodHero greets me and suggests something
    And I say nonsense
    And FoodHero says he can't understand me

    When I go to the help view through the link
    Then I see the help view

  Scenario: Sharing when suggestion liked
    Given FoodHero has started and I accept alerts
    And FoodHero greets me and suggests something
    And I like the restaurant
    And I see my answer "Like"

    When I go to the share view through the link
    Then I see the share view

    When I share "Food Hero is cool"
    And I share through Mail
    Then I see the Mail App with text "Download it for free from www.jennius.co.uk"

    When I cancel the Mail App
    And I see the share view
    And I go back
    Then I see the conversation view

  Scenario: Sharing from conversation
    Given FoodHero has started and I accept alerts
    And FoodHero greets me and suggests something

    When I touch share
    And I share through Mail
    Then I see the Mail App with text "Download Food Hero from www.jennius.co.uk"

  Scenario: Giving product feedback through help
    Given FoodHero has started and I accept alerts
    And FoodHero greets me and suggests something
    And I go to the help view
    And I see the help view
    When I go to the feedback view
    Then I see the feedback view

    When I cancel the feedback view
    Then I see the help view

    When I go to the feedback view
    And I see the feedback view
    When I send feedback in the feedback view
    Then I see the help view

  Scenario: Giving product feedback when Food Hero asks for
    Given FoodHero has started and I accept alerts
    And FoodHero greets me and suggests something
    And FoodHero asks for product feedback
    And I want to give product feedback
    Then FoodHero says Thank you for giving product feedback

    When I go to the feedback view through the link
    Then I see the feedback view

