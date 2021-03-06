//
// Created by Jorg on 18/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class SearchErrorControlInputTests: XCTestCase {
    func test_encodeAndDecode_ShouldRestoreObject() {
        let error = NetworkError()
        let input = SearchErrorControlInput(error: error)

        let decodedInput = CodingHelper.encodeAndDecode(input)

        XCTAssertEqual(decodedInput, input)
    }
}
