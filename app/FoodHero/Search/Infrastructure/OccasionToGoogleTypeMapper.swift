//
// Created by Jorg on 17/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class OccasionToGoogleTypeMapper: NSObject {
    static let cafe = ["cafe"]
    static let breakfast =  ["bakery"] + cafe
    static let eating = ["restaurant", "meal_takeaway", "meal_delivery"]
    static let drinking =  ["bar", "night_club"]

    public class func map(occasion: String) -> [String] {


        switch (occasion) {
        case Occasions.breakfast():
            return breakfast
        case Occasions.lunch():
            return eating
        case Occasions.snack():
            return cafe
        case Occasions.dinner():
            return eating
        case Occasions.drink():
            return drinking
        case "":
            return breakfast + eating + drinking
        default:
            assert(false, "occasion '\(occasion)' not found")
        }
    }
}
