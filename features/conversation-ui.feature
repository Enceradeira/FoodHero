Feature: User interacts with app through conversation

  Background:
    Given FoodHero has started

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
