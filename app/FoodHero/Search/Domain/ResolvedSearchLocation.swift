//
// Created by Jorg on 02/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class ResolvedSearchLocation: NSObject {
    let location: CLLocation
    let locationDescription: String

    init(location: CLLocation, description: String) {
        self.location = location
        self.locationDescription = description
    }

}
