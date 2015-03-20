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

        sendInput(UserIntentUnclearError(state: currState))

        assertLastStatementIs("FH:DidNotUnderstandAndAsksForRepetition", state: currState)

        sendInput(UserIntentUnclearError(state: currState))
        assertSecondLastStatementIs("FH:DidNotUnderstandAndAsksForRepetition", state: currState)
        assertLastStatementIs("FH:DidNotUnderstandAndAsksForRepetition", state: currState)
    }
}
