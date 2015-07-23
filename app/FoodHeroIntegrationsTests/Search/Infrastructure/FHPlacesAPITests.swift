//
// Created by Jorg on 19/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import XCTest
import FoodHero

class FHPlacesAPITests: XCTestCase {

    let _norwich = CLLocation(latitude: 52.629539, longitude: 1.302700)

    func test_findPlaces_ShouldReturnSomething() {
        let api = FHPlacesAPI(baseUrl: "http://localhost:3001/")

        let result: AnyObject = api.findPlaces("Indian", occasion: "dinner", location: _norwich)

        XCTAssertTrue(result is [Place])
        let places = result as! [Place]
        XCTAssertGreaterThan(count(places), 1)
        let firstPlace = places[0]
        XCTAssertGreaterThan(count(firstPlace.placeId), 0)
        XCTAssertNotNil(firstPlace.location)
        XCTAssertGreaterThan(firstPlace.cuisineRelevance, 0)
        XCTAssertGreaterThan(firstPlace.priceLevel, 0)
    }

    func test_findPlaces_ShouldReturnError_WhenNetworkingError() {
        let api = FHPlacesAPI(baseUrl: "http://localhost:8847112344/")

        let result: AnyObject = api.findPlaces("Indian", occasion: "dinner", location: _norwich)
        XCTAssertTrue(result is NSError)
    }
}

