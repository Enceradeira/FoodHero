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

    When User says good bye
    Then FoodHero says good bye

    When User wants to search for another restaurant
    Then FoodHero asks asks what User wishes to eat

  Scenario: User doesn't allow to access location-API
    When FoodHero greets users and asks what they wished to eat
    And User wishes to eat "British" food by typing it
    Then FoodHero asks for access to location-services

    When User doesn't allow access to location-services
    Then FoodHero asks to enable location-services in settings

    When User says that problem with location-service has been fixed
    Then User answers with I fixed the problem, please try again
    And FoodHero asks to enable location-services in settings

  Scenario: FoodHero can't find any restaurants
    Given FoodHero will not find any restaurants

    When User wishes to eat "Indian" food by choosing it
    And User allows access to location-services
    Then FoodHero says that nothing was found

    When User says try again
    Then FoodHero says that nothing was found

    When FoodHero will find restaurant
    And User says try again
    Then FoodHero suggests something for "Indian" food

  Scenario: User does naughty things
    When FoodHero greets users and asks what they wished to eat
    And User touches send without entering anything
    Then FoodHero still greets users and asks what they wished to eat

    When User wishes to eat "African" food by choosing it
    And User allows access to location-services
    And User touches send without entering anything
    And User finds restaurant looks too cheap
    And User touches send without entering anything
    Then FoodHero still suggests something for "African" food

  Scenario: User does things differently
    # choosing cuisine from list
    When User wishes to eat "South American, Greek, Indian" food by choosing it
    And User allows access to location-services
    Then User answers with "South American, Greek or Indian" food
    Then FoodHero suggests something for "South American, Greek or Indian" food
    # clicking on bubble while input list is displayed
    When User touches input list button
    Then User can see the feedback list
    And User touches a conversation bubble
    Then User can't see the feedback list
