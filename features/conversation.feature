Feature: User interacts with app through conversation

  Background:
    Given FoodHero has started

  Scenario: User logs in for the first time and goes through all suggestion feedbacks
    When FoodHero greets users and asks what they wished to eat
    And User wishes to eat "British" food by typing it
    Then FoodHero asks for access to location-services
    When User allows access to location-services
    Then User answers with "British" food
    Then FoodHero suggests something for "British" food

    When User doesn't like that restaurant
    Then User answers with "I don't like that restaurant"
    And FoodHero suggests something else for "British" food

    When User finds restaurant too far away
    Then User answers with "It's too far away"
    And FoodHero suggests something else for "British" food

    When User finds restaurant looks too cheap
    Then User answers with "It looks too cheap"
    And FoodHero suggests something else for "British" food

    When User finds restaurant looks too expensive
    Then User answers with "It looks too expensive"
    And FoodHero suggests something else for "British" food

    When User likes the restaurant
    Then User answers with "I like it"
    And FoodHero asks what to do next


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
    When User says that problem with location-service has been fixed
    Then User answers with I fixed the problem, please try again
    And FoodHero asks to enable location-services in settings


  Scenario: User does naughty things
    When FoodHero greets users and asks what they wished to eat
    And User clicks send without entering anything
    Then FoodHero still greets users and asks what they wished to eat

    When User wishes to eat "African" food by choosing it
    And User allows access to location-services
    And User clicks send without entering anything
    And User finds restaurant looks too cheap
    And User clicks send without entering anything
    Then FoodHero still suggests something for "African" food