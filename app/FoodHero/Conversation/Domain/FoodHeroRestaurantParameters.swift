//
// Created by Jorg on 13/08/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

// Contains information about a restaurant but is not a suggestion
public class FoodHeroRestaurantParameters: FoodHeroParameters {
    private let _restaurant: Restaurant
    public init(semanticId: String, state: String?, restaurant: Restaurant, expectedUserUtterances: ExpectedUserUtterances?) {
        _restaurant = restaurant;
        super.init(semanticId: semanticId, state: state, expectedUserUtterances: expectedUserUtterances)
    }

    public var restaurant: Restaurant {
        get {
            return _restaurant;
        }
    }
}