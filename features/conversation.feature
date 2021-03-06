@app
Feature: User interacts with app through conversation

  Scenario: I log in for the first time and go through all suggestion feedback
    Given FoodHero has started and I accept alerts
    Then FoodHero greets me and suggests something

    When I don't like the restaurant
    Then I see my answer "Dislike"
    And FoodHero suggests something else

    When I ask where it is
    Then FoodHero tells me the restaurants location
    When I go to the map through the restaurant location link
    Then I see the map
    When I go back
    Then I see the conversation view

    When I find the restaurant too far away
    Then I see my answer "tooFarAway"
    And FoodHero suggests something else

    When I find the restaurant looks too cheap
    Then I see my answer "tooCheap"
    And FoodHero suggests something else

    When I find the restaurant looks too expensive
    Then I see my answer "tooExpensive"
    And FoodHero suggests something else

    When I want the closest restaurant now
    Then I see my answer "theClosestNow"
    And FoodHero suggests something else

    When I like the restaurant
    Then I see my answer "Like"
    And FoodHero asks if there's anything else

    When I want to search for another restaurant
    Then FoodHero asks what I wished to eat

    When I wish to eat "Sushi"
    Then FoodHero suggests something else

 Scenario: I end conversation and continue later
    Given FoodHero has started and I accept alerts
    And FoodHero greets me and suggests something
    And I like the restaurant
    Then FoodHero asks if there's anything else

    When I say there's nothing else
    Then FoodHero says good bye

    When I say good bye
    Then FoodHero says still good bye

    When I greet FoodHero
    Then FoodHero greets me and suggests something

 Scenario: I ask where the restaurant is
   Given FoodHero has started and I accept alerts
   And FoodHero greets me and suggests something
   And I like the restaurant and ask where it is
   Then FoodHero comments my choice and tells me the restaurants location
   And FoodHero asks if there's anything else

   When I go to the map through the restaurant location link
   Then I see the map
   When I go back
   Then I see the conversation view

 Scenario: I become feed up with Food Hero
   Given FoodHero has started and I accept alerts
   Then FoodHero greets me and suggests something

   When I don't like the restaurant
   And FoodHero suggests something else

   When I want FoodHero to abort search
   Then FoodHero asks if there's anything else after failure

 Scenario: I search a restaurant for another occasion and another kind of food
   Given FoodHero has started and I accept alerts
   Then FoodHero greets me and suggests something
   And FoodHero mentions the occasion

   When I dislike the occasion
   Then FoodHero asks me for the occasion

   When I want to have some drinks
   Then FoodHero suggests something

   When I dislike the kind of food
   Then I see my answer DislikesKindOfFood
   And FoodHero asks what kind of food I wished to eat

   When I wish to eat "Sushi"
   Then I see my answer with "Sushi" food
   And FoodHero suggests something else

  Scenario: I want to search for another occasion without disliking occasion first
    Given FoodHero has started and I accept alerts
    Then FoodHero greets me and suggests something
    And FoodHero mentions the occasion

    When I want to have some drinks
    Then FoodHero suggests something

  Scenario: I don't allow FoodHero to access location-API
    Given I have answered the data collection alert
    And I have answered the notification alert
    When FoodHero asks for access to the location-services
    And I don't allow access to the location-services
    Then FoodHero asks to enable location-services in settings

    When I say that problem with location-service has been fixed
    Then I answer with I fixed the problem, please try again
    And FoodHero asks to enable location-services in settings

  Scenario: FoodHero can't find any restaurants
    Given FoodHero has started and I accept alerts
    And FoodHero greets me and suggests something
    And FoodHero will not find any restaurants
    And I don't like the restaurant
    Then FoodHero says that nothing was found

    When I want FoodHero to start over again
    Then FoodHero asks what I wished to eat

    When I wish to eat "Sushi"
    Then FoodHero says that nothing was found

    # Following is commented because instruments becomes too slow and test fails
 #   When I want to have some drinks
 #   Then FoodHero says that nothing was found

 #   Given FoodHero will find restaurants
 #   When I want FoodHero to start over again
 #   And FoodHero asks what I wished to eat
 #   And I wish to eat "Sushi"
 #   Then FoodHero suggests something else

 #   Given FoodHero will not find any restaurants
 #   When I don't like the restaurant
 #   Then FoodHero says that nothing was found
 #   When I want FoodHero to abort search
 #   Then FoodHero asks if there's anything else after failure
 #   When I say there's nothing else
 #   Then FoodHero says good bye

 #   Given I greet FoodHero
 #   And FoodHero says that nothing was found
 #   And FoodHero will find restaurants
 #   When I wish to eat "Sushi"
 #   Then FoodHero suggests something else

  Scenario: FoodHero is offline
    Given FoodHero has started and I accept alerts
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
    Given FoodHero has started and I accept alerts
    And FoodHero greets me and suggests something
    When I say nonsense
    Then FoodHero says he can't understand me

    When I say nonsense
    Then FoodHero says he can't understand me

    When I find the restaurant too far away
    Then FoodHero suggests something else

  Scenario: Internet is very slow
    Given FoodHero has started and I accept alerts
    And FoodHero greets me and suggests something
    And FoodHero is very slow in responding
    When I don't like the restaurant
    Then FoodHero says that he's busy right now
    And FoodHero suggests something else

