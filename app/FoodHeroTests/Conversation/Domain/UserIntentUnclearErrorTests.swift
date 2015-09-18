//
// Created by Jorg on 18/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class UserIntentUnclearErrorTests: XCTestCase {
    func test_encodeDecode_ShouldRestoreObject(){
        let restaurant = RestaurantBuilder().build()
        let utterance = ExpectedUserUtterances.whenAskedForSuggestionFeedback("dinner")
        let error = UserIntentUnclearError(state: "myState", expectedUserUtterances: ExpectedUserUtterances(utterances: ["myUtterance"]))

        let decodedError = CodingHelper.encodeAndDecode(error)
        XCTAssertEqual(decodedError, error)
    }
}
