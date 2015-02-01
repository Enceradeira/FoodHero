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
}
