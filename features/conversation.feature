Feature: User interacts with app through conversation

  Scenario: User logs in for the first time
    Given FoodHero has started
    Then FoodHero greets users and asks what they wished to eat
    When User wishes to eat British food
    Then FoodHero asks for access to location-services
    When User allows access to location-services
    Then User answers with British food
    Then FoodHero suggests something for British food
    When User doesn't like that restaurant
    Then FoodHero suggests something else for British food

  Scenario: User doesn't allow to access location-API
    Given FoodHero has started
    Then FoodHero greets users and asks what they wished to eat
    When User wishes to eat British food
    Then FoodHero asks for access to location-services
    When User doesn't allow access to location-services
    Then FoodHero asks to enable location-services in settings