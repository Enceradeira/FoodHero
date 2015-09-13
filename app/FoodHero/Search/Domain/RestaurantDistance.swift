//
// Created by Jorg on 02/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class RestaurantDistance: NSObject, NSCoding {
    public override func isEqual(other: AnyObject?) -> Bool {
        if let other = other as? RestaurantDistance {
            if distanceFromSearchLocation != other.distanceFromSearchLocation {
                return false;
            }
            if _searchLocationDescription != other._searchLocationDescription {
                return false;
            }
            if searchLocation.distanceFromLocation(other.searchLocation) != 0 {
                return false;
            }
            return true;
        }
        return false;
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(distanceFromSearchLocation, forKey: "distanceFromSearchLocation")
        aCoder.encodeObject(searchLocation, forKey: "searchLocation");
        aCoder.encodeObject(_searchLocationDescription, forKey: "_searchLocationDescription");
    }

    public required init(coder aDecoder: NSCoder) {
        distanceFromSearchLocation = aDecoder.decodeDoubleForKey("distanceFromSearchLocation")
        _searchLocationDescription = aDecoder.decodeObjectForKey("_searchLocationDescription") as! String
        searchLocation = aDecoder.decodeObjectForKey("searchLocation") as! CLLocation
    }

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
