//
// Created by Jorg on 26/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

public class TalkerEngineBasicTests: TalkerEngineTests {

    func test_talk_shouldUtterSomething() {
        let script = TestScript().say({ $0.words("Hello") })

        assert(dialog: ["Hello"], forExecutedScript: script)
    }

    func test_talk_shouldYieldCustomData_WhenAssociatedWithUtterance() {
        var utterance: TalkerUtterance? = nil
        let script = TestScript()
        .say({
            $0.words("Hello", withCustomData: "Context-Greeting")
        })

        executeScript(script).subscribeNext {
            object in
            utterance = object as? TalkerUtterance
        }

        let customData = utterance!.customData
        XCTAssertEqual(customData.count, 1)
        XCTAssertEqual(customData[0] as String, "Context-Greeting")
    }


    func test_talk_shouldYieldCustomData_WhenAssociatedWithInput() {
        var utterance: TalkerUtterance? = nil
        let script = TestScript().say({ $0.words("How are you?") }).waitResponse()

        let expectation = expectationWithDescription("")
        executeScript(script).subscribeNext {
            object in
            utterance = object as? TalkerUtterance
            let customData = utterance?.customData
            if (customData != nil && customData!.count == 1 && customData![0] as String == "Context-Response") {
                expectation.fulfill()
            }
        }

        sendInput("Good, and you?", "Context-Response");

        waitForExpectationsWithTimeout(0.01, handler: nil)
    }

    func test_talk_shouldSendCustomDataToContinueWith_WhenWaitingResponse() {
        var utterance: TalkerUtterance? = nil

        let expectation = expectationWithDescription("")
        let script = TestScript().say({ $0.words("How are you?") }).waitResponse(andContinueWith: {
            response,script in
            if( response.customData[0] as String == "Context-Response")
            {
                expectation.fulfill()
            }
        })
        sendInput("Good, and you?", "Context-Response");

        executeScript(script).asynchronouslyWaitUntilCompleted(nil)

        waitForExpectationsWithTimeout(0.01, handler: nil)
    }

    func test_talk_shouldYieldEmptyArrayAsCustomData_WhenNoCustomDataIsAssociatedatedWithUtterance() {
        var utterance: TalkerUtterance? = nil
        let script = TestScript().say({ $0.words("Hello") })

        executeScript(script).subscribeNext {
            object in
            utterance = object as? TalkerUtterance
        }

        XCTAssertEqual(utterance!.customData.count, 0)
    }

    func test_talk_shouldRepeat_WhenScriptExecutedTwice() {
        let script = TestScript().say({ $0.words("Hello") })

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
        let dialog = executeScript(TestScript().say({ $0.words("Hello") }).say({ $0.words("World") }));

        let hasCompleted = dialog.asynchronouslyWaitUntilCompleted(nil)

        XCTAssertEqual(hasCompleted, true)
    }

    func test_talk_shouldListenToReponse() {
        let script = TestScript()
        .say({ $0.words("How are you?") })
        .waitResponse()

        assert(dialog: ["How are you?", "Good"],
                forExecutedScript: script,
                whenInputIs: { _ in return "Good" })
    }

    func test_talk_shouldNotWaitForReponse_WhenNoResponseYetGiven() {
        let script = TestScript()
        .say({ $0.words("How are you?") })
        .waitResponse()
        .say({ $0.words("Brilliant!") })

        assert(utterance: "How are you?", exists: true, inExecutedScript: script, atPosition: 0)
    }

    func test_talk_shouldWaitResponseAndThenContinue() {
        let script = TestScript()
        .say({ $0.words("How are you?") })
        .waitResponse()
        .say({ $0.words("I'm fine, thanks!") })

        assert(dialog: ["How are you?", "Good, and you?", "I'm fine, thanks!"],
                forExecutedScript: script,
                whenInputIs: { _ in return "Good, and you?" }
        )
    }

    func test_talk_shouldWaitResponseAndThenContinueWithAsynchAction() {
        let script = TestScript()
        .say({ $0.words("How are you?") })
        .waitResponse(andContinueWith: {
            _, script in

            script.say({
                definition in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    definition.words("Very good")
                    return
                }
                return definition
            })
            return
        })

        assert(dialog: ["How are you?", "Good, and you?", "Very good"],
                forExecutedScript: script,
                whenInputIs: {
                    switch $0 {
                    case "How are you?": return "Good, and you?"
                    default: return nil
                    }
                }
        )
    }
}
