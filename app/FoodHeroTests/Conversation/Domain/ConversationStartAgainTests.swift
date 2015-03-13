//
// Created by Jorg on 12/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

public class ConversationStartAgainTests: ConversationTestsBase {
    let _norwich = CLLocation(latitude: 52.631944, longitude: 1.2988)
    let _restaurant = RestaurantBuilder().build()

    public override func setUp() {
        super.setUp()


    }

    func test_UStartAgain_ShouldResetConversation_WhenSearching() {
        sendInput(UserUtterances.cuisinePreference("British Food", text: "British please"))
        sendInput(UserUtterances.suggestionFeedbackForTooCheap(_restaurant, currentUserLocation: _norwich, text: "British please"))
        sendInput(UserUtterances.wantsToStartAgain("Start again please"))

        assertLastStatementIs("FH:ConfirmsRestart;FH:OpeningQuestion", state:"askForFoodPreference")
    }

    func test_UStartAgain_ShouldResetConversation_WhenSearchErrorOccurred(){
        configureRestaurantSearchForLatitude(48, longitude:-22){
            $0.injectFindNothing()
        }
        sendInput(UserUtterances.cuisinePreference("British Food", text: "British please"))
        sendInput(UserUtterances.wantsToStartAgain("Start again please"))

        assertLastStatementIs("FH:ConfirmsRestart;FH:OpeningQuestion", state:"askForFoodPreference")
    }
}
