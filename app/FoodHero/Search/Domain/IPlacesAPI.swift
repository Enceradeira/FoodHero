//
// Created by Jorg on 23/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

@objc
public protocol IPlacesAPI {
    func findPlaces(cuisine: String, occasion: String, location: CLLocation) -> AnyObject
}
