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

    func test_talk_shouldUtterOnlyOnce_WhenMonolog() {
        let script = TestScript().say("Hello").say("World")

        assert(dialog: ["Hello\n\nWorld"], forExecutedScript: script)
    }

    func test_talk_shouldListenToReponse() {
        let script = TestScript()
        .say("How are you?")
        .waitResponse()

        responseIs("Good")

        assert(dialog: ["How are you?", "Good"], forExecutedScript: script)
    }

    func test_talk_shouldWaitResponseAndThenContinue() {
        let script = TestScript()
        .say("How are you?")
        .waitResponse()
        .say("I'm fine, thanks!")

        assert(utterance: "I'm fine, thanks!", exists: false, inExecutedScript: script)

        responseIs("Good, and you?")

        assert(dialog: ["How are you?", "Good, and you?", "I'm fine, thanks!"], forExecutedScript: script)
    }

    func test_talk_shouldResponseToResponse_WhenFirstResponse() {
        let script = TestScript()
        .say("How are you?")
        .waitResponse(andContinueWith: {
            response, script in
            switch response {
            case "Good": script.say("I'm glad to hear")
            default: script.say("What did you say?")
            }
        })

        responseIs("Good")
        assert(dialog: ["How are you?", "Good", "I'm glad to hear"], forExecutedScript: script)
    }

    func test_talk_shouldResponseToResponse_WhenAlternativeResponse() {
        let script = TestScript()
        .say("How are you?")
        .waitResponse(andContinueWith: {
            response, script in
            switch response {
            case "Good": script.say("I'm glad to hear")
            default: script.say("What did you say?")
            }
        })

        responseIs("*##!!")
        assert(dialog: ["How are you?", "*##!!", "What did you say?"], forExecutedScript: script)
    }
}
