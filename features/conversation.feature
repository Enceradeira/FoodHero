Feature: User interacts with app through conversation

  Background:
    Given FoodHero has started

  Scenario: I log in for the first time and go through all suggestion feedbacks
    When FoodHero greets me and asks what I wished to eat
    And I wish to eat "British" food by typing it
    Then FoodHero asks for access to the location-services
    When I allow access to the location-services
    Then I answer with "British" food
    Then FoodHero suggests something for "British" food

    When I don't like the restaurant
    Then I answer with "I don't like that restaurant"
    And FoodHero suggests something else for "British" food

    When I find the restaurant too far away
    Then I answer with "It's too far away"
    And FoodHero suggests something else for "British" food

    When I find the restaurant looks too cheap
    Then I answer with "It looks too cheap"
    And FoodHero suggests something else for "British" food

    When I find the restaurant looks too expensive
    Then I answer with "It looks too expensive"
    And FoodHero suggests something else for "British" food

    When I like the restaurant
    Then I answer with "I like it"
    And FoodHero asks what to do next

    When I say good bye
    Then FoodHero says good bye

    When I want to search for another restaurant
    Then FoodHero asks what I wished to eat

  Scenario: I don't allow FoodHero to access location-API
    When FoodHero greets me and asks what I wished to eat
    And I wish to eat "British" food by typing it
    Then FoodHero asks for access to the location-services

    When I don't allow access to the location-services
    Then FoodHero asks to enable location-services in settings

    When I say that problem with location-service has been fixed
    Then I answer with I fixed the problem, please try again
    And FoodHero asks to enable location-services in settings

  Scenario: FoodHero can't find any restaurants
    Given FoodHero will not find any restaurants
    When I wish to eat "Indian" food by choosing it
    And I allow access to the location-services
    Then FoodHero says that nothing was found
    When I say try again
    Then FoodHero says that nothing was found

    Given FoodHero will find restaurants
    When I say try again
    Then FoodHero suggests something for "Indian" food

    Given FoodHero can't access a network
    When I don't like the restaurant
    Then FoodHero says that nothing was found
    When I want FoodHero to abort search
    Then FoodHero asks what to do next after failure
    When I say good bye
    Then FoodHero says good bye

