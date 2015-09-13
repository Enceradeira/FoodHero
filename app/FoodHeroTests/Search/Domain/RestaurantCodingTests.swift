//
// Created by Jorg on 12/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class RestaurantCodingTests: XCTestCase {
    func test_encodeDecode_ShouldRestoreObject() {
        let restaurant = RestaurantBuilder().build()

        let decodedRestaurant = CodingHelper.encodeAndDecode(restaurant)
        XCTAssertEqual(decodedRestaurant, restaurant)
    }
}

