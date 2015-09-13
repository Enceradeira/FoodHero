//
// Created by Jorg on 12/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationParametersTests: XCTestCase {
    func test_encodeAndDecode_ShouldRestoreObject() {
        let parameter = ConversationParameters(semanticId:"ARG")

        let decodedParameter = CodingHelper.encodeAndDecode(parameter)

        XCTAssertEqual(decodedParameter, parameter)
    }
}

