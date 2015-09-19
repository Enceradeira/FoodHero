//
// Created by Jorg on 19/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class PriceRangeTests: XCTestCase {
    func test_encodeAndDecode_ShouldRestoreObject() {
        let input = PriceRange.priceRangeWithoutRestriction()

        let decodedInput = CodingHelper.encodeAndDecode(input)

        XCTAssertEqual(decodedInput, input)
    }
}
