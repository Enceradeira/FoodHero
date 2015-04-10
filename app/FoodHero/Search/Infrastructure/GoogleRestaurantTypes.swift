//
// Created by Jorg on 10/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

/// see:  https://developers.google.com/places/supported_types
public class GoogleRestaurantTypes: NSObject {
    public class func restaurant()->String{
        return "restaurant"
    }
    public class func bakery()->String{
        return "bakery"
    }
    public class func bar()->String{
        return "bar"
    }
    public class func cafe()->String{
        return "cafe"
    }
    public class func food()->String{
        return "food"
    }
    public class func meal_takeaway()->String{
        return "meal_takeaway"
    }
    public class func meal_delivery()->String{
        return "meal_delivery"
    }
    public class func night_club()->String{
        return "night_club"
    }
}
