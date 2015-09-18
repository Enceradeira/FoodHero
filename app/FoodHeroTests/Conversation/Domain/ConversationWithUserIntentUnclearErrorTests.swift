//
// Created by Jorg on 19/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationWithUserIntentUnclearErrorTests: ConversationTestsBase {
    let _restaurant = RestaurantBuilder().build()
    let _norwich = CLLocation(latitude: 52.631944, longitude: 1.2988)

    func test_UserIntentUnclearError_ShouldTriggerFHDidNotUnderstandAndAsksForRepetitionRepeatably() {
        let currState = FHStates.askForFoodPreference()

        sendInput(UserIntentUnclearError(state: currState, expectedUserUtterances: ExpectedUserUtterances(utterances: [])))

        assertLastStatementIs("FH:DidNotUnderstandAndAsksForRepetition", state: currState)

        sendInput(UserIntentUnclearError(state: currState, expectedUserUtterances: ExpectedUserUtterances(utterances: [])))
        assertSecondLastStatementIs("FH:DidNotUnderstandAndAsksForRepetition", state: currState)
        assertLastStatementIs("FH:DidNotUnderstandAndAsksForRepetition", state: currState)
    }

    func test_userIntenUnclearError_ShouldForwardExpectedUserUtterancesToNextStatemet(){
        let currState = FHStates.askForFoodPreference()
        let expectedUserUtterances = ExpectedUserUtterances(utterances: [])

        sendInput(UserIntentUnclearError(state: currState, expectedUserUtterances: expectedUserUtterances))

        assertLastStatementIs("FH:DidNotUnderstandAndAsksForRepetition", state: currState)
        let lastStatement = conversation.getStatement(conversation.getStatementCount()-1)

        XCTAssertEqual(lastStatement.expectedUserUtterances(), expectedUserUtterances)
    }

    func test_UserIntentUnclearError_ShouldTriggerFHDidNotUnderstandAndAsksForRepetitionRepeatably_WhenInterruptWithUserFeedbackRequest() {
        let currState = FHStates.askForProductFeedback()

        sendInput(RequestProductFeedbackInterruption())
        sendInput(UserIntentUnclearError(state: currState, expectedUserUtterances: ExpectedUserUtterances(utterances: [])))

        assertLastStatementIs("FH:DidNotUnderstandAndAsksForRepetition", state: currState)

        sendInput(UserIntentUnclearError(state: currState, expectedUserUtterances: ExpectedUserUtterances(utterances: [])))
        assertSecondLastStatementIs("FH:DidNotUnderstandAndAsksForRepetition", state: currState)
        assertLastStatementIs("FH:DidNotUnderstandAndAsksForRepetition", state: currState)

        sendInput(UserUtterances.doesnWantToGiveProductFeedback("No"))
        assertLastStatementIs("FH:RegretsUserNotGivingProductFeedback", state: FHStates.askForSuggestionFeedback())
        assertLastStatementIs("FH:FirstQuestion", state: FHStates.askForSuggestionFeedback())
    }

    func test_userIntenUnclearError_ShouldForwardExpectedUserUtterancesToNextStatemet_WhenInterruptWithUserFeedbackRequest(){
        let currState = FHStates.askForProductFeedback()
        let expectedUserUtterances = ExpectedUserUtterances(utterances: [])

        sendInput(RequestProductFeedbackInterruption())
        sendInput(UserIntentUnclearError(state: currState, expectedUserUtterances: expectedUserUtterances))

        assertLastStatementIs("FH:DidNotUnderstandAndAsksForRepetition", state: currState)
        let lastStatement = conversation.getStatement(conversation.getStatementCount()-1)

        XCTAssertEqual(lastStatement.expectedUserUtterances(), expectedUserUtterances)
    }

}
