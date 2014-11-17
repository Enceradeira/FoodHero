Feature: User interacts with app through conversation

  Background:
    Given FoodHero has started

  Scenario: I can't say anything until FoodHero answers
    Given FoodHero greets me and asks what I wished to eat
    When I touch send without entering anything
    Then FoodHero still greets me and asks what I wished to eat

    Given FoodHero is very slow in responding
    When I wish to eat "American" food by typing it
    And I allow access to the location-services
    Then I can't touch input list button
    And I can't enter text
    And I can't touch send
    When FoodHero suggests something for "African" food
    Then I can touch input list button
    And I can enter text

  Scenario: I do things differently
    # choosing cuisine from list
    Given I wish to eat "Indian" food by typing it
    And I allow access to the location-services
    Then I answer with "Indian" food
    And FoodHero suggests something for "Indian" food
    # clicking on bubble while input list is displayed
    Given I touch input list button
    Then I can see the feedback list
    When I touch a conversation bubble
    Then I can't see the feedback list
    # clicking on text field while input list is displayed but direct text-input disabled (which is the case for suggestion-feedback list)
    When I touch input list button
    Then I can see the feedback list
    And I can't enter text
    When I touch the text field
    Then I can't enter text

  Scenario: A long conversation
    Given I wish to eat "British" food by typing it
    And I allow access to the location-services
    And FoodHero suggests something for "British" food
    And I don't like the restaurant
    And FoodHero suggests something for "British" food
    And I find the restaurant too far away
    And FoodHero suggests something for "British" food
    And I find the restaurant looks too cheap
    And FoodHero suggests something for "British" food
    When I touch input list button
    Then I can see last suggestion

  Scenario: Use a cheat to see semantic-Ids of tokens
    When I configure FoodHero to show Semantic-Ids
    And I wish to eat "British" food by typing it
    And I allow access to the location-services
    Then FoodHero displays Semantic-ID "FH:Suggestion" in last suggestion


