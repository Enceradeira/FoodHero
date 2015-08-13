//
// Created by Jorg on 13/08/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationLocationRequestTests: ConversationTestsBase {
    let _restaurant = RestaurantBuilder().build()

    func test_USuggestionFeedbackLikeWithLocationRequest_ShouldTellUserLocationOfRestaurant() {
        sendInput(UserUtterances.suggestionFeedbackForLikeWithLocationRequest(_restaurant, text: "That sounds good. Where is it?"))

        assertLastStatementIs("FH:CommentChoiceAndTellRestaurantLocation", state: "askForWhatToDoNext")
        assertLastStatementIs("FH:WhatToDoNextCommentAfterSuccess", state: "askForWhatToDoNext")

        let lastStatement = conversation.getStatement(conversation.getStatementCount() - 1)
        XCTAssertTrue(lastStatement.text().rangeOfString("Norwich") != nil, "No vicinity is told to user")
    }

    func test_ULocationRequest_ShouldTellUserLocationOfRestaurant() {
        sendInput(UserUtterances.locationRequest("Where is it?"))

        assertLastStatementIs("FH:TellRestaurantLocation", state: "askForSuggestionFeedback")

        let lastStatement = conversation.getStatement(conversation.getStatementCount() - 1)
        XCTAssertTrue(lastStatement.text().rangeOfString("Norwich") != nil, "No vicinity is told to user")
    }

}
