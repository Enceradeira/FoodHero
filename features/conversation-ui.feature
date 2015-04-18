Feature: User interacts with app through conversation

  Background:
    Given FoodHero has started and can access location-services

  Scenario: I can't say anything until FoodHero answers
    When FoodHero greets me and suggests something
    And I touch send without entering anything
    Then FoodHero still greets me and suggests something

    Given FoodHero is very slow in responding
    When I don't like the restaurant
    Then I can't touch the microphone button
    And I can't enter text
    And I can't touch send
    When FoodHero suggests something else for "African" food
    Then I can touch the microphone button
    And I can enter text

  Scenario: A long conversation
    When FoodHero greets me and suggests something
    And I don't like the restaurant
    And FoodHero suggests something for "British" food
    And I find the restaurant too far away
    And FoodHero suggests something for "British" food
    And I find the restaurant looks too cheap
    And FoodHero suggests something for "British" food
    When I touch input list button
    Then I can see last suggestion

  Scenario: Use a cheat to see semantic-Ids of tokens
    When FoodHero greets me and suggests something
    And I configure FoodHero to show Semantic-Ids
    And I don't like the restaurant
    And FoodHero suggests something else for "British" food
    Then FoodHero displays Semantic-ID "FH:" in last suggestion


