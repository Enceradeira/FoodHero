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

    var _input: NSMutableArray?

    public override func setUp() {
        super.setUp()

        _input = NSMutableArray()
    }

    func responseIs(text: String) {
        _input!.addObject(text)
    }

    func executeScript(script: Script) -> RACSignal {
        return TalkerEngine(script, _input!.rac_sequence).execute()
    }

    func executeDialogFor(script: Script) -> [String] {
        let dialog = executeScript(script)
        return (dialog.toArray() as [String])
    }

    func assert(#utterance: String, inExecutedScript script: Script, atPosition expectedPosition: Int? = nil) {
        assert(utterance: utterance, inDialog: executeScript(script), atPosition: expectedPosition)
    }

    func assert(#utterance: String, inDialog dialog: RACSignal, atPosition expectedPosition: Int? = nil) {
        var positionCount: Int = 0
        var actualPosition: Int? = nil

        dialog.map {
            (text: AnyObject?) in
            return GenericWrapper(text: (text! as String), position: positionCount++)
        }.filter {
            (object: AnyObject?) in
            let tuple = (object as GenericWrapper<(text:String, position:Int)>)
            return tuple.element.text == utterance
        }.subscribeNext {
            (object: AnyObject?) in
            let tuple = (object as GenericWrapper<(text:String, position:Int)>)
            if (actualPosition == nil) {
                actualPosition = tuple.element.position
            }

            // trigger a context switch in order that we always get to the XCA_waitForStatus below before we call XCA_notify here
            dispatch_async(dispatch_get_main_queue()) {
                self.XCA_notify(XCTAsyncTestCaseStatus.Succeeded)
            }
        }

        XCA_waitForStatus(XCTAsyncTestCaseStatus.Succeeded, timeout: 0.01)

        if (expectedPosition != nil) {
            XCTAssertEqual(actualPosition ?? (-1), expectedPosition!, "Utterance is at wrong position")
        }
    }

    public func test_talk_shouldUtterSomething() {
        let script = Script().say("Hello")

        assert(utterance: "Hello", inExecutedScript: script, atPosition: 0)
    }

    public func test_talk_shouldRepeat_WhenScriptExecutedTwice() {
        let script = Script().say("Hello")

        for index in 1 ... 2 {
            let utterance = executeDialogFor(script)[0]
            assert(utterance: "Hello", inExecutedScript: script, atPosition: 0)
        }
    }

    public func test_talk_shouldComplete_WhenNothingIsToBeSaid() {
        let dialog = executeScript(Script());

        let hasCompleted = dialog.asynchronouslyWaitUntilCompleted(nil)

        XCTAssertEqual(hasCompleted, true)
    }

    public func test_talk_shouldComplete_WhenEverythingHasBeenSaid() {
        let dialog = executeScript(Script().say("Hello").say("World"));

        let hasCompleted = dialog.asynchronouslyWaitUntilCompleted(nil)

        XCTAssertEqual(hasCompleted, true)
    }

    public func test_talk_shouldUtterOnlyOnce_WhenMonolog() {
        let script = Script().say("Hello").say("World")

        let utterance = executeDialogFor(script)[0]

        assert(utterance: "Hello\n\nWorld", inExecutedScript: script, atPosition: 0)
    }

    public func test_talk_shouldListenToReponse() {
        let script = Script()
        .say("How are you?")
        .waitResponse();

        responseIs("Good")

        assert(utterance: "Good", inExecutedScript: script, atPosition: 1)
    }
}