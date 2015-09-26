//
// Created by Jorg on 25/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationOccasionPreferenceTests: ConversationTestsBase {
    func test_Conversation_ShouldNotTriggerNewSearch_WhenConversationIsRestored() {
        resetConversationWhenIsWithFeedbackRequest(false)

        sendInput(UserUtterances.occasionPreference(TextAndLocation(text: "lunch"), text: "I want to have lunch"))

        let nrSearches = self.restaurantSearchStub.NrCallsToFindPlaces

        resetRepositoryCache()
        codeAndDecodeWhenIsWithFeedbackRequest(false)

        let nrSearchesAfterRestore = self.restaurantSearchStub.NrCallsToFindPlaces
        XCTAssertEqual(nrSearches, nrSearchesAfterRestore)
    }
}
