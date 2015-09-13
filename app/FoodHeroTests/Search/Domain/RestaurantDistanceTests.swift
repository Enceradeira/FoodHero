//
// Created by Jorg on 12/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class RestaurantDistanceTests: XCTestCase {
    func test_encodeDecode_ShouldRestoreObject() {
        let distance = RestaurantDistanceBuilder().build()

        let decodedDistance = CodingHelper.encodeAndDecode(distance)
        XCTAssertEqual(decodedDistance, distance)
    }
}

