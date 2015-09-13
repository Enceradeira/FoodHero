//
// Created by Jorg on 13/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class USuggestionFeedbackParametersTests : XCTestCase {
    func test_encodeAndDecode_ShouldRestoreObject() {
        let restaurant = RestaurantBuilder().build()
        let parameter = USuggestionFeedbackParameters(semanticId: "TRE", modelAnswer: "No", restaurant:restaurant)

        let decodedParameter = CodingHelper.encodeAndDecode(parameter)

        XCTAssertEqual(decodedParameter, parameter)
    }
}