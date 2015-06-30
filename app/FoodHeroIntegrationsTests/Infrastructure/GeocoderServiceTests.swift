//
// Created by Jorg on 29/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import XCTest
import FoodHero

class GeocoderServiceTests: XCTestCase {

    let _cathedralStreetLocation = CLLocation(latitude: 52.629539, longitude: 1.302700)
    let _cathedralStreetAddress = "18 Cathedral Street, Norwich, United Kingdom"
    let _service = GeocoderService()

    func test_geocodeAddressString_ShouldReturnCoordinate_WhenAddressFound() {
        var location: CLLocation?
        let expectation = expectationWithDescription("")

        let coordinates = _service.geocodeAddressString(_cathedralStreetAddress)
        coordinates.subscribeNext {
            location = $0 as! CLLocation?
        }
        coordinates.subscribeCompleted {
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(30, handler: nil)
        XCTAssertNotNil(location)
        if location == nil {
            return
        }

        let distance = location!.distanceFromLocation(_cathedralStreetLocation)
        XCTAssertLessThanOrEqual(distance, 100, "Location incorrectly resolved")
    }

    func test_geocodeAddressString_ShouldReturnNil_WhenAddressNotFound() {
        var location: CLLocation?
        let expectation = expectationWithDescription("")

        let coordinates = _service.geocodeAddressString("----&&%/")
        coordinates.subscribeNext {
            location = $0 as! CLLocation?
        }
        coordinates.subscribeCompleted {
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(30, handler: nil)
        XCTAssertNil(location)
    }
}
