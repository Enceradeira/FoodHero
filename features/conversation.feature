Feature: User interacts with app through conversation

  Scenario: User logs in for the first time
    Given FoodHero has started
    Then FoodHero greets users and asks what they wished to eat
    When User wishes to eat British food
    Then FoodHero asks for access to location-services
    When User allows access to location-services
    Then User answers with British food
    Then FoodHero suggests "Zuni Cafe, 1658 Market St, San Francisco"

  Scenario: User doesn't allow to access location-API
    Given FoodHero has started
    Then FoodHero greets users and asks what they wished to eat
    When User wishes to eat British food
    Then FoodHero asks for access to location-services
    When User doesn't allow access to location-services
    Then FoodHero regrets that he can't access location
    Then FoodHero says goodbye