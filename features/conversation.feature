Feature: User interacts with app through conversation

  Scenario: User logs in for the first time
    Given FoodHero has started
    Then FoodHero greets users and asks what they wished to eat
    When User wishes to eat British food
    Then User answers with British food
    Then FoodHero suggests "The Maids Head Hotel, 20 Tombland, Norwich"