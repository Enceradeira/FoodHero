//
// Created by Jorg on 22/05/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationIsVeryBusyAtTheMomentTests: ConversationTestsBase {

    override func setUp() {
        super.setUp()

        restaurantRepository.simulateSlowResponse(true)
        ConversationScript.searchTimeout = 0.001
    }

      /*
    func test_Conversation_ShouldSayFHIsVeryBusyAtTheMoment_WhenSearchTimeoutOccurs() {
        self.resetConversation()

        let waitStatement = expectationWithDescription("Statement")

        self.conversation.statementIndexes().subscribeNext {
            // collect utterances
            (object: AnyObject?) in
            let index = (object! as! UInt)
            let statement = self.conversation.getStatement(index)
            if statement.semanticId() == "FH:Suggestion" {
                waitStatement.fulfill()
            }


            NSLog("Utterance: \(statement.semanticId())")
        }


        waitForExpectationsWithTimeout(10, handler: nil)

        assertSecondLastStatementIs("FH:IsVeryBusyAtTheMoment", state: nil)
        assertLastStatementIs("FH:Suggestion", state: FHStates.askForSuggestionFeedback())
    }   */
}
