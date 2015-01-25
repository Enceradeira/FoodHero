//
//  TalkerEngineTests.swift
//  FoodHero
//
//  Created by Jorg on 24/01/2015.
//  Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import XCTest
import FoodHero

public class TalkerEngineTests: XCTestCase {

    var _input: RACSubject?

    public override func setUp() {
        super.setUp()

        _input = RACSubject()
    }

    func respondWith(text: String) {
        _input!.sendNext(text)
    }

    func getDialogFor(script: Script) -> RACSignal {
        return TalkerEngine(script, _input!).execute()
    }

    func executeDialogFor(script: Script) -> [String] {
        let dialog = getDialogFor(script)
        return (dialog.toArray() as [String])
    }

    public func test_talk_shouldUtterSomething() {
        let script = Script().say("Hello")

        let utterance = executeDialogFor(script)[0]

        XCTAssertEqual(utterance, "Hello")
    }

    public func test_talk_shouldRepeat_WhenScriptExecutedTwice() {
        let script = Script().say("Hello")

        for index in 1 ... 2 {
            let utterance = executeDialogFor(script)[0]
            XCTAssertEqual(utterance, "Hello")
        }
    }

    public func test_talk_shouldComplete_WhenNothingIsToBeSaid() {
        let dialog = getDialogFor(Script());

        let hasCompleted = dialog.asynchronouslyWaitUntilCompleted(nil)

        XCTAssertEqual(hasCompleted, true)
    }

    public func test_talk_shouldComplete_WhenEverythingHasBeenSaid() {
        let dialog = getDialogFor(Script().say("Hello").say("World"));

        let hasCompleted = dialog.asynchronouslyWaitUntilCompleted(nil)

        XCTAssertEqual(hasCompleted, true)
    }

    public func test_talk_shouldUtterOnlyOnce_WhenMonolog() {
        let script = Script().say("Hello").say("World")

        let utterance = executeDialogFor(script)[0]

        XCTAssertEqual(utterance, "Hello\n\nWorld")
    }

    public func test_talk_shouldListenToReponse() {
        let signal = RACSignal.createSignal {
            subscriber in
            subscriber.sendNext("Good")
            return nil
        }

        let script = Script()
        .say("How are you?")
        .waitResponse();

        respondWith("Good")
        let dialog = getDialogFor(script)

        dialog.filter {
            (text: AnyObject?) -> Bool in
            return (text! as String) == "Good"
        }.subscribeNext {
            t in
            self.XCA_notify(XCTAsyncTestCaseStatus.Succeeded);
        }

        XCA_waitForTimeout(1)
    }
}