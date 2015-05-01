//
// Created by Jorg on 12/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

public class ConversationUserWantsToAbortTests: ConversationTestsBase {
    let _restaurant = RestaurantBuilder().build()

    func test_UWantsToAbort_ShouldAskUserWhatToDoNext() {
        sendInput(UserUtterances.suggestionFeedbackForTooCheap(_restaurant, text: "Too cheap"))
        sendInput(UserUtterances.wantsToAbort("Ohhh dear! Forgetit"))

        assertLastStatementIs("FH:WhatToDoNextCommentAfterFailure", state: FHStates.askForWhatToDoNext())
    }
}