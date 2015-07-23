//
// Created by Jorg on 19/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import XCTest
import FoodHero

class FHPlacesUrlBuilderTests: XCTestCase {

    let _location = CLLocation(latitude: 52.629539, longitude: -0.126236)

    func test_buildUrl_ShouldReturnCorrectUrl_WhenCuisineAndOccasionEmpty() {
        let builder = FHPlacesUrlBuilder(baseUrl: "http://localhost:3001")

        let url = builder.buildUrlWithCuisine("", occasion: "", location: _location)

        XCTAssertEqual(url, "http://localhost:3001/api/v1/places?cuisine=&occasion=&location=52.629539,-0.126236")
    }

    func test_buildUrl_ShouldReturnCorrectUrl_WhenBaseUrlIsNotTerminatedWithSlash() {
        let builder = FHPlacesUrlBuilder(baseUrl: "http://localhost:3001/")

        let url = builder.buildUrlWithCuisine("", occasion: "", location: _location)

        XCTAssertEqual(url, "http://localhost:3001/api/v1/places?cuisine=&occasion=&location=52.629539,-0.126236")
    }


    func test_buildUrl_ShouldReturnCorrectUrl_WhenCuisineAndOccasionNotEmpty() {
        let builder = FHPlacesUrlBuilder(baseUrl: "http://localhost:3001")

        let url = builder.buildUrlWithCuisine("Indian Food", occasion: "lunch", location: _location)

        XCTAssertEqual(url, "http://localhost:3001/api/v1/places?cuisine=Indian%20Food&occasion=lunch&location=52.629539,-0.126236")
    }

}

