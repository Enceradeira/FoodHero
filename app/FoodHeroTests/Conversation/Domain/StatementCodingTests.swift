//
// Created by Jorg on 11/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class StatementCodingTests: XCTestCase {
    func test_encodeDecode_ShouldRestoreStatement(){
        let restaurant = RestaurantBuilder().build()
        let utterance = ExpectedUserUtterances.whenAskedForSuggestionFeedback("dinner")
        let statement = Statement(semanticId: "A", text:"B", state:"C",suggestedRestaurant:restaurant,expectedUserUtterances:utterance)

        let decodedStatemnt = CodingHelper.encodeAndDecode(statement)
        XCTAssertEqual(decodedStatemnt, statement)
    }


}
