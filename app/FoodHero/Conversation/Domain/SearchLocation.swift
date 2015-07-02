//
// Created by Jorg on 02/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class SearchLocation {
    let locationDescription: String?
    let location: CLLocation
    let distance: long

    public init(location: CLLocation, locationDescription: String?) {
        locationDescription = locationDescription
        location = location
    }

}
