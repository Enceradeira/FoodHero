//
// Created by Jorg on 24/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class FoodHeroSuggestionParameters: FoodHeroParameters {
    private let _restaurant: Restaurant
    public init(semanticId: String, state: String, restaurant: Restaurant) {
        _restaurant = restaurant;
        super.init(semanticId: semanticId, state: state)
    }

    public var restaurant: Restaurant {
        get {
            return _restaurant;
        }
    }
}
