//
// Created by Jorg on 23/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

public class PlacesAPISpy: NSObject, IPlacesAPI {
    private var _cuisine: String = ""
    private var _occasion: String = ""
    private var _location: CLLocation! = nil
    private var _nrCallsTofindPlacesWasCalledWithCusine = 0

    public func findPlaces(cuisine: String, occasion: String, location: CLLocation) -> AnyObject {
        _cuisine = cuisine
        _occasion = occasion
        _location = location
        _nrCallsTofindPlacesWasCalledWithCusine++
        return []
    }

    public var NrCallsToFindPlacesWasCalledWithCusine: Int {
        get {
            return _nrCallsTofindPlacesWasCalledWithCusine
        }
    }

    public func findPlacesWasCalledWithCusine(cuisine: String, occasion: String, location: CLLocation) -> Bool {
        return _cuisine == _cuisine && _occasion == _occasion && _location == location
    }
}
