//
// Created by Jorg on 11/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationCodingTests: ConversationTestsBase {
    func test_encodeAndDecode_ShouldRestoreStatements() {
        let decodedConversation = CodingHelper.encodeAndDecode(conversation)

        XCTAssertGreaterThan(decodedConversation.getStatementCount(), 0)
    }

    func test_encodeAndDecode_ShouldRestoreRawConversation() {
        let lastRawSuggestion = conversation.lastRawSuggestion()
        let decodedConversation = CodingHelper.encodeAndDecode(conversation)

        XCTAssertEqual(decodedConversation.lastRawSuggestion(), lastRawSuggestion)
    }
}

