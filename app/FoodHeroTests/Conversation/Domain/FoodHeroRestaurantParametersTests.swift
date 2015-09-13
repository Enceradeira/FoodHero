//
// Created by Jorg on 12/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero


class FoodHeroRestaurantParametersTests: XCTestCase {
    func test_encodeAndDecode_ShouldRestoreObject() {
        let restaurant = RestaurantBuilder().build()
        let utterances = ExpectedUserUtterances.whenAskedForProductFeedback();
        let parameter = FoodHeroRestaurantParameters(semanticId: "ARG", state: "Now", restaurant: restaurant, expectedUserUtterances: utterances)

        let decodedParameter = CodingHelper.encodeAndDecode(parameter)

        XCTAssertEqual(decodedParameter, parameter)
    }
}
