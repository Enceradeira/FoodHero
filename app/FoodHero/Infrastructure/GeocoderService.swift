//
// Created by Jorg on 29/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import CoreLocation

public class GeocoderService: NSObject, IGeocoderService {
    public func geocodeAddressString(address: String) -> RACSignal {
        let subject = RACSubject()
        let startTime = NSDate()

        CLGeocoder().geocodeAddressString(address, inRegion: nil) {
            (anyObjects, error) in

            let timeElapsed = startTime.timeIntervalSinceNow
            GAIService.logTimingWithCategory(GAICategories.externalCallTimings(), name: GAITimingNames.geocoderService(), label: "", interval: timeElapsed)

            var result: CLLocation? = nil
            if error == nil && anyObjects != nil && anyObjects!.count > 0 {
                let placeMarks = anyObjects! as [CLPlacemark]
                let placeMark = placeMarks[0]
                result = placeMark.location
            } else {
                var label : String;
                if( error == nil ) {
                    label = "GeocoderService-NoResult"
                }
                else{
                    label = "GeocoderService-\(error!.domain)-\(error!.code)"
                }
                GAIService.logEventWithCategory(GAICategories.negativeExperience(), action: GAIActions.negativeExperienceError(), label: label, value: 0)
            }
            subject.sendNext(result)
            subject.sendCompleted()
        }
        return subject
    }
}
