//
// Created by Jorg on 13/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class UserParametersTests: XCTestCase {
    func test_encodeAndDecode_ShouldRestoreObject() {
        let textAndLocation = TextAndLocation(text: "I want Indian food in York", location: "York")
        let parameter = UserParameters(semanticId: "TRE", parameter: textAndLocation, modelAnswer: "No")

        let decodedParameter = CodingHelper.encodeAndDecode(parameter)

        XCTAssertEqual(decodedParameter, parameter)
    }
}