//
// Created by Jorg on 19/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class SearchProfileTests: XCTestCase {
    func test_encodeAndDecode_ShouldRestoreObject() {
        let restaurant = RestaurantBuilder().build()
        let range = PriceRange.priceRangeWithoutRestriction()
        let distance = DistanceRange(nearerThan: 0.56)
        let location = CLLocation(latitude: 52.631944, longitude: 1.2988)
        let input = SearchProfile(cuisine: "Indian", priceRange: range, maxDistance: distance, occasion: "Lunch", location: location);

        let decodedInput = CodingHelper.encodeAndDecode(input)

        XCTAssertEqual(decodedInput, input)
    }
}

