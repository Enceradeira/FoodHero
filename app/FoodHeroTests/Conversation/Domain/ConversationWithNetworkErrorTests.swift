//
// Created by Jorg on 14/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationWithNetworkErrorTests: ConversationTestsBase {
    let _restaurant = RestaurantBuilder().build()
    let _norwich = CLLocation(latitude: 52.631944, longitude: 1.2988)

    func test_NetworkError_ShouldTriggerFHHasNetworkErrorRepeatably() {
        sendInput(NetworkError())

        assertLastStatementIs("FH:HasNetworkError", state: FHStates.networkError())

        sendInput(NetworkError())
        assertSecondLastStatementIs("FH:HasNetworkError", state: FHStates.networkError())
        assertLastStatementIs("FH:HasNetworkError", state: FHStates.networkError())
    }

    func test_UTryAgain_ShouldTriggerFHToRepeastItsLastQuestion() {
        sendInput(NetworkError())
        sendInput(UserUtterances.tryAgainNow("Try again now"))

        assertLastStatementIs("FH:BeforeRepeatingUtteranceAfterError", state: FHStates.askForFoodPreference())
        assertLastStatementIs("FH:OpeningQuestion", state: FHStates.askForFoodPreference())
    }

    func test_USuggestionFeedbackDislike_ShouldTriggerFHSuggestion_WhenNetworkErrorFixed() {
        sendInput(UserUtterances.cuisinePreference("French", text: "I like french food"))
        sendInput(NetworkError())
        sendInput(UserUtterances.tryAgainNow("Try again now"))

        let statementCount = conversation.getStatementCount()
        sendInput(UserUtterances.suggestionFeedbackForDislike(_restaurant, text: "Rubbish"))

        XCTAssertGreaterThan(conversation.getStatementCount(), statementCount, "No new suggestion was added")
        assertLastStatementIs("FH:Suggestion", state: FHStates.askForSuggestionFeedback())
    }
}
