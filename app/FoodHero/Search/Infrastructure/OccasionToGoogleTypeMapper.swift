//
// Created by Jorg on 17/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class OccasionToGoogleTypeMapper: NSObject {

    public class func map(occasion: String) -> [String] {
        switch (occasion) {
        case Occasions.breakfast():
            return ["bakery", "cafe"]
        case Occasions.lunch():
            return ["restaurant", "meal_takeaway", "meal_delivery"]
        case Occasions.snack():
            return ["cafe"]
        case Occasions.dinner():
            return ["restaurant", "meal_takeaway", "meal_delivery"]
        case Occasions.drinks():
            return ["bar", "night_club"]
        default:
            assert(false, "occasion '\(occasion)' not found")
        }
    }
}
