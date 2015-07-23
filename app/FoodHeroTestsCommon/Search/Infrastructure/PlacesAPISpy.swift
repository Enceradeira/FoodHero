//
// Created by Jorg on 23/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

public class PlacesAPISpy: NSObject, IPlacesAPI {
    var _cuisine: String = ""
    var _occasion: String = ""
    var _location: CLLocation! = nil

    public func findPlaces(cuisine: String, occasion: String, location: CLLocation) -> AnyObject {
        _cuisine = cuisine
        _occasion = occasion
        _location = location
        return []
    }

    public func findPlacesWasCalledWithCusine(cuisine: String, occasion: String, location: CLLocation) -> Bool {
        return _cuisine == _cuisine && _occasion == _occasion && _location == location
    }
}
