//
// Created by Jorg on 26/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

public class TalkerEngineBasicTests: TalkerEngineTests {

    func test_talk_shouldUtterSomething() {
        let script = TestScript().say(oneOf: { $0.words("Hello") })

        assert(dialog: ["Hello"], forExecutedScript: script)
    }

    func test_talk_shouldYieldCustomData_WhenAssociatedWithUtterance() {
        var utterance: TalkerUtterance? = nil
        let script = TestScript()
        .say(oneOf: {
            $0.words("Hello", withCustomData: "Context-Greeting")
        })


        executeScript(script).subscribeNext {
            object in
            utterance = object as? TalkerUtterance
        }

        let customData = utterance!.customData
        XCTAssertEqual(customData.count, 1)
        XCTAssertEqual(customData[0] as! String, "Context-Greeting")
    }

    func test_talk_shouldUtterSomethingJustSometimes() {
        let script = TestScript()
        .saySometimes(oneOf: {
            $0.words("very")
        }, withTag: "SayVery")
        .say {
            $0.words("rich")
        }


        randomizerWillChoose(forTag: "SayVery", value: true)
        assert(dialog: ["very\n\nrich"], forExecutedScript: script)

        randomizerWillChoose(forTag: "SayVery", value: false)
        assert(dialog: ["rich"], forExecutedScript: script)
    }

    func test_talk_shouldYieldCustomData_WhenAssociatedWithInput() {
        var utterance: TalkerUtterance? = nil
        let script = TestScript()
        .say(oneOf: { $0.words("How are you?") })
        .waitResponse(catch: nil)


        let expectation = expectationWithDescription("")
        executeScript(script).subscribeNext {
            object in
            utterance = object as? TalkerUtterance
            let customData = utterance?.customData
            if (customData != nil && customData!.count == 1 && customData![0] as! String == "Context-Response") {
                expectation.fulfill()
            }
        }

        sendInput("Good, and you?", "Context-Response");

        waitForExpectationsWithTimeout(0.01, handler: nil)
    }

    func test_talk_shouldSendCustomDataToContinueWith_WhenWaitingResponse() {
        var utterance: TalkerUtterance? = nil

        let expectation = expectationWithDescription("")
        let script = TestScript().say(oneOf: { $0.words("How are you?") }).waitResponse(andContinueWith: {
            response, script in
            if (response.customData[0] as! String == "Context-Response") {
                expectation.fulfill()
            }
            return script
        }, catch: nil)
        sendInput("Good, and you?", "Context-Response");

        executeScript(script)

        waitForExpectationsWithTimeout(0.01, handler: nil)
    }

    func test_talk_shouldYieldEmptyArrayAsCustomData_WhenNoCustomDataIsAssociatedatedWithUtterance() {
        var utterance: TalkerUtterance? = nil
        let script = TestScript()
        .say(oneOf: { $0.words("Hello") })


        executeScript(script).subscribeNext {
            object in
            utterance = object as? TalkerUtterance
        }

        XCTAssertEqual(utterance!.customData.count, 0)
    }

    func test_talk_shouldRepeat_WhenScriptExecutedTwice() {
        let script = TestScript()
        .say(oneOf: { $0.words("Hello") })


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
        let dialog = executeScript(TestScript()
        .say(oneOf: { $0.words("Hello") })
        .say(oneOf: { $0.words("World") })
        );

        let hasCompleted = dialog.asynchronouslyWaitUntilCompleted(nil)

        XCTAssertEqual(hasCompleted, true)
    }

    func test_talk_shouldListenToReponse() {
        let script = TestScript()
        .say(oneOf: { $0.words("How are you?") })
        .waitResponse(catch: nil)

        assert(dialog: ["How are you?", "Good"],
                forExecutedScript: script,
                whenInputIs: { _ in return "Good" })
    }

    func test_talk_shouldYieldPreviousUtterance_WhenNoResponseYetGiven() {
        let script = TestScript()
        .say(oneOf: { $0.words("How are you?") })
        .waitResponse(catch: nil)
        .say(oneOf: { $0.words("Brilliant!") })


        assert(utterance: "How are you?", exists: true, inExecutedScript: script, atPosition: 0)
    }

    func test_talk_shouldWaitResponseAndThenContinue() {
        let script = TestScript()
        .say(oneOf: { $0.words("How are you?") })
        .waitResponse(catch: nil)
        .say(oneOf: { $0.words("I'm fine, thanks!") })


        assert(dialog: ["How are you?", "Good, and you?", "I'm fine, thanks!"],
                forExecutedScript: script,
                whenInputIs: { _ in return "Good, and you?" }
        )
    }

    func test_talk_shouldWaitResponseAndThenContinueWithAsynchAction() {
        let script = TestScript()
        .say(oneOf: { $0.words("How are you?") })
        .waitResponse(andContinueWith: {
            _, future in
            return future.define {
                $0.say(oneOf: {
                    definition in
                    self.async {
                        definition.words("Very good")
                        future
                        return
                    }
                    return definition
                })
            }
        }, catch: nil)
        .say(oneOf: { $0.words("So, what did you do yesterday?") })


        assert(dialog: ["How are you?", "Good, and you?", "Very good\n\nSo, what did you do yesterday?"],
                forExecutedScript: script,
                whenInputIs: {
                    utterance, engine in
                    switch utterance {
                    case "How are you?": return "Good, and you?"
                    default: return nil
                    }
                }
        )
    }

    func test_talk_shouldHandleErrorsOnInputStream_WhenCatched() {
        let script = TestScript()
        .say(oneOf: { $0.words("Hello") })
        .waitResponse(catch: { e, s in s.say(oneOf: { $0.words("Error \(e.domain)") }) })
        .say(oneOf: { $0.words("World") })

        assert(dialog: ["Hello", "Error is not good\n\nWorld"],
                forExecutedScript: script,
                whenInputIs: {
                    utterance, engine in
                    switch utterance {
                    case "Hello": return NSError(domain: "is not good", code: 0, userInfo: nil)
                    default: return nil
                    }
                }
        )
    }

    func test_talk_shouldIgnoreErorsOnInputStream_WhenNotCatched() {
        let script = TestScript()
        .say(oneOf: { $0.words("Hello") })
        .waitResponse(catch: nil)
        .say(oneOf: { $0.words("World") })

        assert(dialog: ["Hello", "World"],
                forExecutedScript: script,
                whenInputIs: {
                    utterance, engine in
                    switch utterance {
                    case "Hello": return NSError(domain: "Hello Error", code: 0, userInfo: nil)
                    default: return nil
                    }
                }
        )
    }

    func test_talk_shouldHandleEveryErrorOnInputStream_WhenSeveralErrors() {
        let script = TestScript()
        .say(oneOf: { $0.words("1") })
        .waitResponse(catch: { e, s in s.say(oneOf: { $0.words("Catch 1: \(e.domain)") }) })
        .say(oneOf: { $0.words("2") })
        .waitResponse(catch: nil)
        .say(oneOf: { $0.words("3") })
        .waitResponse(catch: { e, s in s.say(oneOf: { $0.words("Catch 2: \(e.domain)") }) })
        .say(oneOf: { $0.words("5") })

        assert(dialog: ["1", "Catch 1: Error A\n\n2", "3", "Catch 2: Error C\n\n5"],
                forExecutedScript: script,
                whenInputIs: {
                    utterance, engine in
                    switch utterance {
                    case "1": return NSError(domain: "Error A", code: 0, userInfo: nil)
                    case "Catch 1: Error A\n\n2": return NSError(domain: "Error B", code: 0, userInfo: nil)
                    case "3": return NSError(domain: "Error C", code: 0, userInfo: nil)
                    default: return nil
                    }
                }
        )
    }

    func test_talk_shouldNotCallResponseContinuation_WhenErrorOccurred() {
        let script = TestScript()
        .waitResponse(andContinueWith: {
            return $1.define {
                $0.say {
                    $0.words("That shouldn't be said")
                }
            }
        }, catch: { e, s in s.say(oneOf: { $0.words("This should be said") }) })

        assert(dialog: ["This should be said"],
                forExecutedScript: script,
                whenInputIs: {
                    i in return NSError(domain: "Hello Error", code: 0, userInfo: nil)
                }
        )
    }

    func test_talk_shouldSaySomethingAndContinueWithFutureScript() {
        let script = TestScript()
        .say(oneOf: { $0.words("Hi") })
        .continueWith(continuation: {
            futureScript in
            self.async {
                futureScript.define {
                    $0.say {
                        $0.words("How are you?")
                    }
                }
            }
            return futureScript
        });

        assert(utterance: "Hi", exists: true, inExecutedScript: script, atPosition: 0)
        assert(utterance: "How are you?", exists: true, inExecutedScript: script, atPosition: 1)
    }

    func test_talk_ShouldStreamInputImmediatly_WhenResponseIsEmpty() {
        let script = TestScript()
        .say(oneOf: { $0.words("Hello") })
        .waitResponse(andContinueWith: {
            return $1.defineEmpty() // No output produced
        }, catch: nil)
        .waitResponse(catch: nil)

        sendInput("World")

        assert(utterance: "World", exists: true, inExecutedScript: script, atPosition: 1)
    }

    func test_talk_ShouldStreamInputImmediatly_WhenResponseDoesntProduceOutput() {
        let script = TestScript()
        .say(oneOf: { $0.words("Hello") })
        .waitResponse(andContinueWith: {
            return $1.define {
                // Waiting for another response without producing output
                $0.waitResponse(andContinueWith: {
                    return $1.defineEmpty() // No output produced
                }, catch: nil)
            }
        }, catch: nil)
        .waitResponse(catch: nil)

        sendInput("World")

        assert(utterance: "World", exists: true, inExecutedScript: script, atPosition: 1)
    }

    func test_talk_ShouldInterruptAndResumeConversation_WhenThereIsAnInteruption() {
        let script = TestScript()
        .say(oneOf: { $0.words("What do you want?") })
        .waitResponse(catch: nil)
        .say(oneOf: { $0.words("OK") })

        let subScript = TestScript().say(oneOf: { $0.words("Sorry, what's your name by the way?") })
        .waitResponse(andContinueWith: {
            return $1.define {
                $0.say {
                    $0.words("Ok. So, what do you want?")
                }
            }
        }, catch: nil)


        assert(dialog: ["What do you want?", "Sorry, what's your name by the way?", "My name is John", "Ok. So, what do you want?", "a beer", "OK"],
                forExecutedScript: script,
                whenInputIs: {
                    utterance, engine in
                    switch utterance {
                    case "What do you want?":
                        self.async {
                            engine.interrupt(with: subScript)
                        }
                        return nil
                    case "Sorry, what's your name by the way?":return "My name is John"
                    case "Ok. So, what do you want?": return "a beer"
                    default: return nil
                    }
                }
        )

    }
}
