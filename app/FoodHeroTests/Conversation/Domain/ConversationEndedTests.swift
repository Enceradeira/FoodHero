//
// Created by Jorg on 19/05/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationEndedTests: ConversationTestsBase {
    let _restaurant = RestaurantBuilder().build()

    override func setUp(){
        super.setUp()
        sendInput(UserUtterances.suggestionFeedbackForLike(_restaurant, text: "I like it"))
        sendInput(UserUtterances.wantsToStopConversation("No, that's all"))
    }

    func test_UGoodBye_ShouldTriggerNoFHResponse(){
        sendInput(UserUtterances.goodBye("Bye,Bye"))
        assertLastStatementIs("U:GoodBye", state: nil)

        sendInput(UserUtterances.goodBye("Bye,Bye"))
        assertSecondLastStatementIs("U:GoodBye", state: nil)
        assertLastStatementIs("U:GoodBye", state: nil)
    }

    func test_UHello_ShouldTriggerFHGreetingAndOpeningQuestion(){
        sendInput(UserUtterances.hello("Hello!"))
        assertLastStatementIs("FH:Greeting", state: FHStates.askForSuggestionFeedback())
        assertLastStatementIs("FH:Suggestion", state: FHStates.askForSuggestionFeedback())
    }
}
