@app
Feature: User interacts with app through conversation

  Background:
    Given FoodHero has started and I accept alerts

  @simulateSlowness
  Scenario: I can't say anything until FoodHero answers
    Then I can't touch the microphone button
    And I can't touch help

    When FoodHero greets me and suggests something
    And I touch send without entering anything
    Then FoodHero still greets me and suggests something

    Given FoodHero is very slow in responding
    When I don't like the restaurant
    Then I can't touch the microphone button
    And I can't enter text
    And I can't touch send
    And I can't touch help
    When FoodHero suggests something else
    Then I can touch the microphone button
    And I can enter text
    And I can touch help

  Scenario: A long conversation
    When FoodHero greets me and suggests something
    And I don't like the restaurant
    And FoodHero suggests something else
    And I find the restaurant too far away
    And FoodHero suggests something else
    And I find the restaurant looks too cheap
    And FoodHero suggests something else
    When I touch input list button
    Then I can see last suggestion

  Scenario: Use a cheat to see semantic-Ids of tokens
    When FoodHero greets me and suggests something
    And I configure FoodHero to show Semantic-Ids
    And I don't like the restaurant
    And FoodHero suggests something else
    Then FoodHero displays Semantic-ID "FH:" in last suggestion

  Scenario: User can type his answers
    Given FoodHero greets me and suggests something
    When I don't like the restaurant by typing it
    Then I see my answer "Dislike"