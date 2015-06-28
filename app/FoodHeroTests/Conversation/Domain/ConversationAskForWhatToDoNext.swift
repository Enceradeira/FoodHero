//
// Created by Jorg on 28/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationAskForWhatToDoNext: ConversationTestsBase {
    let _restaurant = RestaurantBuilder().build()


    func test_UCuisinePreference_WhenAskForWhatToDonext() {
        sendInput(UserUtterances.wantsToAbort("Forget about it"))
        sendInput(UserUtterances.cuisinePreference("French", text: "I want French food"))

        assertLastStatementIs("FH:Suggestion", state: "askForSuggestionFeedback")
    }

    func test_UOccasionPreference_WhenAskForWhatToDonext() {
        sendInput(UserUtterances.wantsToAbort("Forget about it"))
        sendInput(UserUtterances.occasionPreference("Lunch", text: "I need lunch"))

        assertLastStatementIs("FH:Suggestion", state: "askForSuggestionFeedback")
    }
}
