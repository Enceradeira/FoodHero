//
// Created by Jorg on 12/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ExpectedUserUtterancesTests: XCTestCase {
    func test_encodeDecode_ShouldRestoreObject() {
        let utterance = ExpectedUserUtterances.whenAskedForSuggestionFeedback("dinner")

        let decodedUtterance = CodingHelper.encodeAndDecode(utterance)
        XCTAssertEqual(decodedUtterance, utterance)
    }
}
