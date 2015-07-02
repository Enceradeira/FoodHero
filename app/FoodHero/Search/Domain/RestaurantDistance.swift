//
// Created by Jorg on 02/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class RestaurantDistance: NSObject {
    private let _searchLocationDescription: String

    let distanceFromSearchLocation: Double
    let searchLocation: CLLocation

    public init(searchLocation: CLLocation, searchLocationDescription: String, distanceFromSearchLocation: Double) {
        self.distanceFromSearchLocation = distanceFromSearchLocation
        self.searchLocation = searchLocation
        _searchLocationDescription = searchLocationDescription
    }

    public var hasPreferredSearchLocation: Bool {
        get {
            return count(_searchLocationDescription) > 0
        }
    }

    public var searchLocationDescription: String {
        get {
            assert(hasPreferredSearchLocation, "SearchLocation can't be retrieved if not hasPreferredSearchLocation")
            return _searchLocationDescription
        }
    }
}
