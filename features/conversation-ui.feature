Feature: User interacts with app through conversation

  Background:
    Given FoodHero has started

  Scenario: I do naughty things
    When FoodHero greets me and asks what I wished to eat
    And I touch send without entering anything
    Then FoodHero still greets me and asks what I wished to eat

    When I wish to eat "African" food by choosing it
    And I allow access to the location-services
    And I touch send without entering anything
    And I find the restaurant looks too cheap
    And I touch send without entering anything
    Then FoodHero still suggests something for "African" food

  Scenario: I do things differently
    # choosing cuisine from list
    When I wish to eat "Indian" food by choosing it
    And I allow access to the location-services
    Then I answer with "Indian" food
    And FoodHero suggests something for "Indian" food
    # clicking on bubble while input list is displayed
    When I touch input list button
    Then I can see the feedback list
    When I touch a conversation bubble
    Then I can't see the feedback list

  Scenario: A long conversation
    Given I wish to eat "British" food by typing it
    And I allow access to the location-services
    And I don't like the restaurant
    And I find the restaurant too far away
    And I find the restaurant looks too cheap
    When I touch input list button
    Then I can see last suggestion
