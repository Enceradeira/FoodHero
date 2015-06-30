//
// Created by Jorg on 30/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class GeocoderServiceStub: NSObject, IGeocoderService {
    private var _location: CLLocation? = CLLocation(latitude: 52.629539, longitude: 1.302700)

    public var geocodeAddressStringParameter: String?

    public func geocodeAddressString(address: String) -> RACSignal {
        geocodeAddressStringParameter = address

        let subject = RACReplaySubject()

        subject.sendNext(_location)
        subject.sendCompleted()

        return subject
    }

    public func injectLocation(location: CLLocation?) {
        _location = location
    }
}
