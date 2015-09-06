//
// Created by Jorg on 17/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationDislikesKindOfFoodTests: ConversationTestsBase {

    func test_Conversation_ShouldAskUserForKindOfFood_WhenKindOfFoodDisliked() {
        sendInput(UserUtterances.dislikesKindOfFood("I don't like burgers"))
        assertLastStatementIs("FH:AskForKindOfFood", state: FHStates.askForFoodPreference())

        sendInput(UserUtterances.cuisinePreference(TextAndLocation(text: "British Food"), text: "British please"))
        assertSecondLastStatementIs("U:CuisinePreference=British Food", state: nil)
        assertLastStatementIs("FH:Suggestion", state: FHStates.askForSuggestionFeedback())
        assertLastStatementIs("FH:FollowUpQuestion", state: FHStates.askForSuggestionFeedback())
    }
}

