//
// Created by Jorg on 11/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationProductFeedbackTests: ConversationTestsBase {
    let _restaurant = RestaurantBuilder().build()

    func test_interruptWithUserFeedbackRequest_ShouldAskUserForFeedback_WhenUserSaysYes() {
        assertLastStatementIs("FH:FirstQuestion", state: FHStates.askForSuggestionFeedback())

        conversation.sendControlInput(RequestProductFeedbackInterruption())
        assertLastStatementIs("FH:AskForProductFeedback", state: FHStates.askForProductFeedback())

        sendInput(UserUtterances.wantsToGiveProductFeedback("Yes"))
        assertLastStatementIs("FH:ThanksForProductFeedback", state: FHStates.askForSuggestionFeedback())
        assertLastStatementIs("FH:FirstQuestion", state: FHStates.askForSuggestionFeedback())
    }

    func test_interruptWithUserFeedbackRequest_ShouldAskUserForFeedback_WhenUserSaysNo() {
        conversation.sendControlInput(RequestProductFeedbackInterruption())
        assertLastStatementIs("FH:AskForProductFeedback", state: FHStates.askForProductFeedback())

        sendInput(UserUtterances.doesnWantToGiveProductFeedback("No"))

        assertLastStatementIs("FH:RegretsUserNotGivingProductFeedback", state: FHStates.askForSuggestionFeedback())
        assertLastStatementIs("FH:FirstQuestion", state: FHStates.askForSuggestionFeedback())
    }

    func test_lastFoodHeroUtteranceProductFeedback_ShouldReturnLastUtteranceBeforeUserWasAskForFeedback() {
        sendInput(UserUtterances.suggestionFeedbackForTooCheap(_restaurant, text: "Too cheap"))
        sendInput(UserUtterances.cuisinePreference(TextAndLocation(text: "French"), text: "I want French food"))

        conversation.sendControlInput(RequestProductFeedbackInterruption())

        let utterance = conversation.lastFoodHeroUtteranceProductFeedback()
        XCTAssertEqual(utterance.utterance, "Do you like it?", "Food Hero asked a question before interrupting with product feedback")
        XCTAssertEqual(utterance.customData.count, 1, "customData must be returend")
    }
}
