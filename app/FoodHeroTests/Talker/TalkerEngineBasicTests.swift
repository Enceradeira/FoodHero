//
// Created by Jorg on 26/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

public class TalkerEngineBasicTests: TalkerEngineTests {

    func test_talk_shouldUtterSomething() {
        let script = TestScript().say("Hello")

        assert(dialog: ["Hello"], forExecutedScript: script)
    }

    func test_talk_shouldRepeat_WhenScriptExecutedTwice() {
        let script = TestScript().say("Hello")

        for index in 1 ... 2 {
            assert(dialog: ["Hello"], forExecutedScript: script)
        }
    }

    func test_talk_shouldComplete_WhenNothingIsToBeSaid() {
        let dialog = executeScript(TestScript());

        let hasCompleted = dialog.asynchronouslyWaitUntilCompleted(nil)

        XCTAssertEqual(hasCompleted, true)
    }

    func test_talk_shouldComplete_WhenEverythingHasBeenSaid() {
        let dialog = executeScript(TestScript().say("Hello").say("World"));

        let hasCompleted = dialog.asynchronouslyWaitUntilCompleted(nil)

        XCTAssertEqual(hasCompleted, true)
    }

    func test_talk_shouldJoinConsecutiveUtterancesTogehter() {
        let script = TestScript()
        .say("Good Morning").say("John")
        .waitResponse(byInvoking: {
            self.responseIs("Hello")
        })
        .say("How are you?").say("Did you sleep well?")
        .waitResponse(byInvoking: {
            self.responseIs("I'm fine")
        })
        .say("OK").say("Good bye")

        assert(dialog: [
                "Good Morning\n\nJohn",
                "Hello",
                "How are you?\n\nDid you sleep well?",
                "I'm fine",
                "OK\n\nGood bye"], forExecutedScript: script)
    }

    func test_talk_shouldJoinConsecutiveUtterancesTogehter_WhenWaitingForResponse() {
        let script = TestScript()
        .say("Good Morning").say("How are you?")
        .waitResponse(byInvoking: {
            // no response during this test
        })

        assert(utterance:"Good Morning\n\nHow are you?", exists:true, inExecutedScript:script)
    }

    func test_talk_shouldListenToReponse() {
        let script = TestScript()
        .say("How are you?")
        .waitResponse(byInvoking: {
            self.responseIs("Good")
        })

        assert(dialog: ["How are you?", "Good"], forExecutedScript: script)
    }

    func test_talk_shouldWaitResponseAndThenContinue() {
        let script = TestScript()
        .say("How are you?")
        .waitResponse(byInvoking: {
            self.responseIs("Good, and you?")
        })
        .say("I'm fine, thanks!")

        assert(dialog: ["How are you?", "Good, and you?", "I'm fine, thanks!"], forExecutedScript: script)
    }

    func test_talk_shouldResponseToResponse_WhenFirstResponse() {
        let script = TestScript()
        .say("How are you?")
        .waitResponse(byInvoking: {
            self.responseIs("Good")
        },
                andContinuingWith: {
                    response, script in
                    switch response {
                    case "Good": script.say("I'm glad to hear")
                    default: script.say("What did you say?")
                    }
                })


        assert(dialog: ["How are you?", "Good", "I'm glad to hear"], forExecutedScript: script)
    }

    func test_talk_shouldResponseToResponse_WhenAlternativeResponse() {
        let script = TestScript()
        .say("How are you?")
        .waitResponse(byInvoking: {
            self.responseIs("*##!!")
        },
                andContinuingWith: {
                    response, script in
                    switch response {
                    case "Good": script.say("I'm glad to hear")
                    default: script.say("What did you say?")
                    }
                })


        assert(dialog: ["How are you?", "*##!!", "What did you say?"], forExecutedScript: script)
    }

    func test_talk_shouldHandleNestedResponses() {
        let script = TestScript()
        .waitResponse(byInvoking: {
            self.responseIs("*##!!")
        },
                andContinuingWith: {
                    _, script in
                    script
                    .say("What?")
                    .waitResponse(byInvoking: {
                        self.responseIs("I mean hello")
                    },
                            andContinuingWith: {
                                _, script in
                                script
                                .say("Now I get it")
                                return
                            })
                    return
                })
        .say("Good bye then")

        assert(dialog: ["*##!!", "What?", "I mean hello", "Now I get it\n\nGood bye then"], forExecutedScript: script)
    }
}
