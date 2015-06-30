//
// Created by Jorg on 29/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import CoreLocation

public class GeocoderService: NSObject, IGeocoderService {
    public func geocodeAddressString(address: String) -> RACSignal {
        let subject = RACSubject()

        CLGeocoder().geocodeAddressString(address, inRegion: nil) {
            (anyObjects, error) in
            var result: CLLocation? = nil
            if error == nil && count(anyObjects) > 0 {
                let placeMarks = anyObjects as! [CLPlacemark]
                let placeMark = placeMarks[0]
                result = placeMark.location
            }
            subject.sendNext(result)
            subject.sendCompleted()
        }
        return subject
    }
}
