//
// Created by Jorg on 12/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class PlaceCodingTests: XCTestCase {
    func test_encodeDecode_ShouldRestoreObject() {
        let norwich = CLLocation(latitude: 52.629539, longitude: 1.302700)
        let place = Place(placeId: "A", location: norwich, priceLevel: 4, cuisineRelevance: 0.87)

        let decodedPlace = CodingHelper.encodeAndDecode(place)
        XCTAssertEqual(decodedPlace, place)
    }
}

