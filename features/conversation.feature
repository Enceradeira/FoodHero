Feature: User interacts with app through conversation

  Scenario: I log in for the first time and go through all suggestion feedback
    When FoodHero has started and can access location-services
    Then FoodHero greets me and suggests something

    When I don't like the restaurant
    Then I see my answer "Dislike"
    And FoodHero suggests something else

    When I find the restaurant too far away
    Then I see my answer "tooFarAway"
    And FoodHero suggests something else

    When I find the restaurant looks too cheap
    Then I see my answer "tooCheap"
    And FoodHero suggests something else

    When I find the restaurant looks too expensive
    Then I see my answer "tooExpensive"
    And FoodHero suggests something else

    When I like the restaurant
    Then I see my answer "Like"
    And FoodHero asks if there's anything else

    When I want to search for another restaurant
    Then FoodHero asks what I wished to eat

    When I wish to eat "Sushi"
    Then FoodHero suggests something else

 Scenario: I end conversation and continue later
    When FoodHero has started and can access location-services
    And FoodHero greets me and suggests something
    And I like the restaurant
    Then FoodHero asks if there's anything else

    When I say there's nothing else
    Then FoodHero says good bye

    When I say good bye
    Then FoodHero says still good bye

    When I greet FoodHero
    Then FoodHero greets me and suggests something

 Scenario: I become feed up with Food Hero
   When FoodHero has started and can access location-services
   Then FoodHero greets me and suggests something

   When I don't like the restaurant
   And FoodHero suggests something else

   When I want FoodHero to abort search
   Then FoodHero asks if there's anything else after failure

 Scenario: I search a restaurant for another occasion and another kind of food
   When FoodHero has started and can access location-services
   Then FoodHero greets me and suggests something
   And FoodHero mentions the occasion

   When I dislike the occasion
   Then FoodHero asks me for the occasion

   When I want to have some drinks
   Then FoodHero suggests something else

   When I dislike the kind of food
   Then I see my answer DislikesKindOfFood
   And FoodHero asks what I wished to eat

   When I wish to eat "Sushi"
   Then I see my answer with "Sushi" food
   And FoodHero suggests something else

  Scenario: I want to search for another occasion without disliking occasion first
    When FoodHero has started and can access location-services
    Then FoodHero greets me and suggests something
    And FoodHero mentions the occasion

    When I want to have some drinks
    Then FoodHero suggests something else

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
    Then FoodHero asks what I wished to eat

    When I wish to eat "Sushi"
    Then FoodHero says that nothing was found

    Given FoodHero will find restaurants
    When I say try again
    And FoodHero asks what I wished to eat
    And I wish to eat "Sushi"
    Then FoodHero suggests something else

    Given FoodHero will not find any restaurants
    When I don't like the restaurant
    Then FoodHero says that nothing was found
    When I want FoodHero to abort search
    Then FoodHero asks if there's anything else after failure
    When I say there's nothing else
    Then FoodHero says good bye

    Given I greet FoodHero
    Then FoodHero says that nothing was found
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
    Then FoodHero suggests something else


