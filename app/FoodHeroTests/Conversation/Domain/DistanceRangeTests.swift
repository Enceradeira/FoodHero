//
// Created by Jorg on 19/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class DistanceRangeTests: XCTestCase {
    func test_encodeAndDecode_ShouldRestoreObject() {
        let input = DistanceRange(nearerThan: 0.56)

        let decodedInput = CodingHelper.encodeAndDecode(input)

        XCTAssertEqual(decodedInput, input)
    }
}
