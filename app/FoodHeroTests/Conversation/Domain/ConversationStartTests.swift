//
// Created by Jorg on 26/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationStartTests: ConversationTestsBase {

    func test_resumeWithFeedbackRequest_ShouldRequestFeedback_WhenThereWasAPreviousConversationAndItsStartedWithFeedbackRequest() {
        resetConversationWhenIsWithFeedbackRequest(false)
        let nrStmts = conversation.getStatementCount()

        codeAndDecodeWhenIsWithFeedbackRequest(true)

        let nrStmtsAfterRestart = conversation.getStatementCount()
        XCTAssertEqual(nrStmtsAfterRestart, nrStmts + 1, "There should only the feedback request be added")
        assertLastStatementIs("FH:AskForProductFeedback", state: FHStates.askForProductFeedback())
    }

    func test_resumeWithFeedbackRequest_ShouldGreetAndRequestFeedback_WhenThereWasNoPreviousConversationAndItsStartedWithFeedbackRequest() {
        resetConversationWhenIsWithFeedbackRequest(true)

        assertSecondLastStatementIs("FH:Greeting", state: nil)
        assertLastStatementIs("FH:AskForProductFeedback", state: FHStates.askForProductFeedback())
    }

    func test_resumeWithFeedbackRequest_ShouldDoNothing_WhenThereWasAPreviousConversationAndItsStartedWithoutFeedbackRequest() {
        resetConversationWhenIsWithFeedbackRequest(false)
        let nrStmts = conversation.getStatementCount()

        codeAndDecodeWhenIsWithFeedbackRequest(false)

        let nrStmtsAfterRestart = conversation.getStatementCount()
        XCTAssertEqual(nrStmtsAfterRestart, nrStmts, "No additional statements should have been generated")
    }

    func test_resumeWithFeedbackRequest_ShouldGreetAndSearch_WhenThereWasNoPreviousConversationAndItsStartedWithoutFeedbackRequest() {
        resetConversationWhenIsWithFeedbackRequest(false)

        assertSecondLastStatementIs("FH:Greeting", state: nil)
        assertLastStatementIs("FH:Suggestion", state: FHStates.askForSuggestionFeedback())
    }

    func test_resumeWithFeedbackRequest_ShouldDoNothing_WhenItsAlreadStartedAndItsStartedAgainWithoutFeedbackRequest() {
        resetConversationWhenIsWithFeedbackRequest(false)
        let nrStmts = conversation.getStatementCount()

        conversation.resumeWithFeedbackRequest(false)

        let nrStmtsAfterRestart = conversation.getStatementCount()
        XCTAssertEqual(nrStmtsAfterRestart, nrStmts, "No additional statements should have been generated")

    }

    func test_resumeWithFeedbackRequest_ShouldRequestFeedbackRequest_WhenItsAlreadyStartedAndIstStartedAgainWithFeedbackRequest() {
        resetConversationWhenIsWithFeedbackRequest(false)
        let nrStmts = conversation.getStatementCount()

        conversation.resumeWithFeedbackRequest(true)

        let nrStmtsAfterRestart = conversation.getStatementCount()
        XCTAssertEqual(nrStmtsAfterRestart, nrStmts + 1, "There should only the feedback request be added")
        assertLastStatementIs("FH:AskForProductFeedback", state: FHStates.askForProductFeedback())
    }


}
