//
// Created by Jorg on 18/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationDislikeOccasionTests: ConversationTestsBase {

    func test_Conversation_ShouldAskForOccasion_WhenOccasionDisliked() {
        let now = NSCalendar.dateFrom(year: 2015, month: 3, day: 25, hour: 10, minute: 56, second: 0)
        environmentStub.injectNow(now)

        sendInput(UserUtterances.dislikesOccasion("I don't want to have breakfast", occasion: "breakfast"))
        assertLastStatementIs("FH:AskForOccasion=snack", state: FHStates.askForSuggestionFeedback())

        sendInput(UserUtterances.occasionPreference("lunch", text: "I want to have lunch"))
        assertSecondLastStatementIs("U:OccasionPreference=lunch", state: nil)
        assertLastStatementIs("FH:Suggestion", state: FHStates.askForSuggestionFeedback())
        assertLastStatementIs("FH:FirstQuestion", state: FHStates.askForSuggestionFeedback())
    }
}
