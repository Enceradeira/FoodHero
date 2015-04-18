Feature: User interacts with app through conversation

  Scenario: I log in for the first time and go through all suggestion feedback
    When FoodHero has started and can access location-services
    Then FoodHero greets me and suggests something

    When I don't like the restaurant
    Then I see my answer "Dislike"
    And FoodHero suggests something else for "British" food

    When I find the restaurant too far away
    Then I see my answer "tooFarAway"
    And FoodHero suggests something else for "British" food

    When I find the restaurant looks too cheap
    Then I see my answer "tooCheap"
    And FoodHero suggests something else for "British" food

    When I find the restaurant looks too expensive
    Then I see my answer "tooExpensive"
    And FoodHero suggests something else for "British" food

    When I like the restaurant
    Then I see my answer "Like"
    And FoodHero asks what to do next

    When I want to search for another restaurant
    Then FoodHero asks what I wished to eat

    When I wish to eat "Asian" food by typing it
    And FoodHero suggests something else for "Asian" food
    And I like the restaurant
    And FoodHero asks what to do next
    And I say good bye
    Then FoodHero says good bye

    When I want to search for another restaurant
    Then FoodHero asks what I wished to eat

  Scenario: I asks to search for the wrong cuisine and I want to start over again
    When FoodHero has started and can access location-services
    Then FoodHero greets me and suggests something
    When I want FoodHero to start over again
    Then FoodHero asks what I wished to eat

  Scenario: I don't allow FoodHero to access location-API
    When FoodHero asks for access to the location-services
    And I don't allow access to the location-services
    Then FoodHero asks to enable location-services in settings

    When I say that problem with location-service has been fixed
    Then I answer with I fixed the problem, please try again
    And FoodHero asks to enable location-services in settings

  Scenario: FoodHero can't find any restaurants
    Given FoodHero has started and can access location-services
    And FoodHero greets me and suggests something
    And FoodHero will not find any restaurants
    And I don't like the restaurant
    Then FoodHero says that nothing was found

    When I say try again
    Then FoodHero says that nothing was found

    Given FoodHero will find restaurants
    When I say try again
    Then FoodHero suggests something for "Indian" food

    Given FoodHero will not find any restaurants
    When I don't like the restaurant
    Then FoodHero says that nothing was found
    When I want FoodHero to abort search
    Then FoodHero asks what to do next after failure
    When I say good bye
    Then FoodHero says good bye

    Given I want to search for another restaurant
    And I wish to eat "British" food by typing it
    And FoodHero says that nothing was found
    When I want FoodHero to start over again
    Then FoodHero asks what I wished to eat

  Scenario: FoodHero is offline
    Given FoodHero has started and can access location-services
    And FoodHero greets me and suggests something
    And FoodHero can't access a network
    And I find the restaurant looks too cheap

    Then FoodHero says he's not connected to the internet
    When I say try again
    Then FoodHero says he's not connected to the internet
    When FoodHero can access a network
    And I say try again
    Then FoodHero asks again what I think about suggestion

  Scenario: FoodHero can't understand user
    Given FoodHero has started and can access location-services
    And FoodHero greets me and suggests something
    When I say nonsense
    Then FoodHero says he can't understand me

    When I say nonsense
    Then FoodHero says he can't understand me

    When I find the restaurant too far away
    Then FoodHero suggests something else for "Italian" food
