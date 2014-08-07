Feature: User interacts with app through conversation

  Background:
    Given FoodHero has started

  Scenario: User logs in for the first time
    When FoodHero greets users and asks what they wished to eat
    And User wishes to eat "British" food by typing it
    Then FoodHero asks for access to location-services
    When User allows access to location-services
    Then User answers with "British" food
    Then FoodHero suggests something for "British" food
    When User doesn't like that restaurant
    Then FoodHero suggests something else for "British" food

  Scenario: User chooses cuisine by typing it
    When User wishes to eat "British" food by typing it
    And User allows access to location-services
    Then User answers with "British" food
    Then FoodHero suggests something for "British" food

  Scenario: User chooses cuisine from list
    When User wishes to eat "South American, Greek, Indian" food by choosing it
    And User allows access to location-services
    Then User answers with "South American, Greek or Indian" food
    Then FoodHero suggests something for "South American, Greek or Indian" food

  Scenario: User doesn't allow to access location-API
    When FoodHero greets users and asks what they wished to eat
    And User wishes to eat "British" food by typing it
    Then FoodHero asks for access to location-services
    When User doesn't allow access to location-services
    Then FoodHero asks to enable location-services in settings