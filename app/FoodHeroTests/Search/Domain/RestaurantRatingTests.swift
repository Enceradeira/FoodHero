//
// Created by Jorg on 12/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class RestaurantRatingTests: XCTestCase {
    func test_encodeDecode_ShouldRestoreObject() {
        let rating = RestaurantRatingBuilder().build()

        let decodedRating = CodingHelper.encodeAndDecode(rating)
        XCTAssertEqual(decodedRating, rating)
    }
}
