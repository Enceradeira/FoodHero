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

    public override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_restaurant, forKey: "_restaurant");
    }

    public required init(coder aDecoder: NSCoder) {
        _restaurant = aDecoder.decodeObjectForKey("_restaurant") as! Restaurant
        super.init(coder: aDecoder)
    }

    public override func isEqual(other: AnyObject?) -> Bool {
        if let other = other as? FoodHeroRestaurantParameters {
            if _restaurant != other._restaurant {
                return false;
            }
            return super.isEqual(other);
        }
        return false;
    }

    public var restaurant: Restaurant {
        get {
            return _restaurant;
        }
    }
}