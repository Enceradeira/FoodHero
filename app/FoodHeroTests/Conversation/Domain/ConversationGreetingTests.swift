//
// Created by Jorg on 10/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationGreetingTests: ConversationTestsBase {

    func test_Conversation_ShouldStartWithGreetingAndSuggestionAndQuestion() {
        let now = NSCalendar.dateFrom(year: 2015, month: 3, day: 25, hour: 13, minute: 0, second: 0)
        self.environmentStub.injectNow(now)

        resetConversation()

        assertLastStatementIs("FH:Greeting", state: FHStates.askForSuggestionFeedback())
        assertLastStatementIs("FH:Suggestion", state: FHStates.askForSuggestionFeedback())
        assertLastStatementIs("FH:FirstQuestion=lunch", state: FHStates.askForSuggestionFeedback())
    }
}
