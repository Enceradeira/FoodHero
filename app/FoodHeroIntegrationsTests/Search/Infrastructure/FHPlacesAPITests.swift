//
// Created by Jorg on 19/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import XCTest
import FoodHero

class FHPlacesAPITests: XCTestCase {

    let _norwich = CLLocation(latitude: 52.629539, longitude: 1.302700)
    var _api: FHPlacesAPI! = nil

    override func setUp() {
        super.setUp()

        let assembly = IntegrationAssembly()
        TyphoonComponents.configure(assembly)
        _api = assembly.placesAPI() as! FHPlacesAPI
    }

    func test_findPlaces_ShouldReturnSomething() {
        let result: AnyObject = _api.findPlaces("Indian", occasion: "dinner", location: _norwich)

        XCTAssertTrue(result is [Place])
        let places = result as! [Place]
        XCTAssertGreaterThan(places.count, 1)
        let firstPlace = places[0]
        XCTAssertGreaterThan(firstPlace.placeId.characters.count, 0)
        XCTAssertNotNil(firstPlace.location)
        XCTAssertGreaterThan(firstPlace.cuisineRelevance, 0)

        let placesWithPriceLevel1 = places.filter {
            $0.priceLevel == 1
        }
        XCTAssertGreaterThan(placesWithPriceLevel1.count, 0, "There should be at least one element with priceLevel 1")
    }

    func test_findPlaces_ShouldReturnError_WhenNetworkingError() {
        let api = FHPlacesAPI(baseUrl: "http://localhost:8847112344/")

        let result: AnyObject = api.findPlaces("Indian", occasion: "dinner", location: _norwich)
        XCTAssertTrue(result is NSError)
    }
}

