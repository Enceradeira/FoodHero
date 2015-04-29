//
// Created by Jorg on 12/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

public class ConversationStartAgainTests: ConversationTestsBase {
    let _restaurant = RestaurantBuilder().build()

    func test_UStartAgain_ShouldResetConversation_WhenSearching() {
        sendInput(UserUtterances.suggestionFeedbackForTooCheap(_restaurant, text: "Too cheap"))
        sendInput(UserUtterances.wantsToStartAgain("Start again please"))

        assertLastStatementIs("FH:ConfirmsRestart;FH:OpeningQuestion", state: FHStates.askForFoodPreference())
    }

    func test_UStartAgain_ShouldResetConversation_WhenSearchErrorOccurred() {
        configureRestaurantSearchForLatitude(48, longitude: -22) {
            $0.injectFindNothing()
        }
        sendInput(UserUtterances.cuisinePreference("British Food", text: "British please"))
        sendInput(UserUtterances.wantsToStartAgain("Start again please"))

        assertLastStatementIs("FH:ConfirmsRestart;FH:OpeningQuestion", state: FHStates.askForFoodPreference())
    }

    func test_UStartAgain_ShouldNotGetSameRestaurantSuggestedAgain_WhenDislikedBefore() {
        let welcomeInn = RestaurantBuilder().withName("Welcome Inn").build()
        let taj = RestaurantBuilder().withName("Taj").build()
        configureRestaurantSearchForLatitude(48, longitude: -22) {
            $0.injectFindResults([welcomeInn, taj])
        }

        // FH suggestes "Welcome Inn"
        resetConversation()
        sendInput(UserUtterances.suggestionFeedbackForDislike(welcomeInn, text: "crap"))

        // Start again
        sendInput(UserUtterances.wantsToStartAgain("Start again please"))
        sendInput(UserUtterances.cuisinePreference("Sausages", text: "I wanna eat Sausages"))

        // FH suggests "Taj" not "Welcome Inn"
        assertLastStatementIs("FH:Suggestion=Taj, 18 Cathedral Street", state: FHStates.askForSuggestionFeedback());
    }
}
