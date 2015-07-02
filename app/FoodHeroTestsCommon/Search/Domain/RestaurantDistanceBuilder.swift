//
// Created by Jorg on 02/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class RestaurantDistanceBuilder: NSObject {

    private var _searchLocation: CLLocation?
    private var _distance: Double?
    private var _searchLocationDescrption: String?

    public func build() -> RestaurantDistance {
        let norwich = CLLocation(latitude: 52.631944, longitude: 1.2988)

        return RestaurantDistance(searchLocation: _searchLocation ?? norwich, searchLocationDescription: _searchLocationDescrption ?? "Norwich", distanceFromSearchLocation: _distance ?? 1.34)
    }

    public func withDistance(distance: Double) -> RestaurantDistanceBuilder {
        _distance = distance;
        return self;
    }

    public func withSearchLocation(location: CLLocation) -> RestaurantDistanceBuilder {
        _searchLocation = location;
        return self;
    }

    public func withSearchLocationDescription(description: String) -> RestaurantDistanceBuilder {
        _searchLocationDescrption = description;
        return self;
    }

}
