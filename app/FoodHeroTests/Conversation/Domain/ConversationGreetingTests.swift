//
// Created by Jorg on 10/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationGreetingTests : ConversationTestsBase {

    func test_Conversation_ShouldStartWithGreetingAndSuggestionAndQuestion(){
        assertLastStatementIs("FH:Greeting", state: FHStates.askForSuggestionFeedback())
        assertLastStatementIs("FH:Suggestion", state: FHStates.askForSuggestionFeedback())
        assertLastStatementIs("FH:FirstQuestion", state: FHStates.askForSuggestionFeedback())
    }
}
