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
    var _randomizer: TalkerRandomizerFake?

    public override func setUp() {
        super.setUp()

        _input = NSMutableArray()
        _randomizer = TalkerRandomizerFake()
    }


    func TestScript(_ resources: ScriptResources? = nil) -> Script {
        var context = TalkerContext()
        context.randomizer = _randomizer!
        context.resources = resources ?? ScriptResources(_randomizer!)
        return Script(context)
    }

    func TestScriptResources() -> ScriptResources {
        return ScriptResources(_randomizer!)
    }

    func responseIs(texts: String...) {
       _input!.addObjectsFromArray(texts)
    }

    func executeScript(script: Script) -> RACSignal {
        return TalkerEngine(script, _input!.rac_sequence).execute()
    }

    func executeDialogFor(script: Script) -> [String] {
        let dialog = executeScript(script)
        return (dialog.toArray() as [String])
    }

    func assert(#utterance: String, exists: Bool, inExecutedScript script: Script, atPosition expectedPosition: Int? = nil) {
        assert(utterance: utterance, exists: exists, inDialog: executeScript(script), atPosition: expectedPosition)
    }

    func assert(#utterance: String, exists: Bool, inDialog dialog: RACSignal, atPosition expectedPosition: Int? = nil) {
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
                self.XCA_notify(exists ? XCTAsyncTestCaseStatus.Succeeded : XCTAsyncTestCaseStatus.Failed)
            }
        }

        let timeoutUSeconds: UInt32 = 100 /*10 ms*/ * 1000;
        if (!exists) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let waitBeforeTimeoutPreventedUSeconds = timeoutUSeconds * 8 / 10
                usleep(waitBeforeTimeoutPreventedUSeconds)  // just before the timeout arises Succeeded is signaled to end the wait for the not existing element
                self.XCA_notify(XCTAsyncTestCaseStatus.Succeeded)
            }
        }
        let timeoutSeconds = NSTimeInterval(Float(timeoutUSeconds) / 1000000)
        XCA_waitForStatus(XCTAsyncTestCaseStatus.Succeeded, timeout: timeoutSeconds)

        if (expectedPosition != nil) {
            XCTAssertEqual(actualPosition ?? (-1), expectedPosition!, "Utterance is at wrong position")
        }
    }

    func assert(dialog expectedDialog: [NSString], forExecutedScript script: Script) {
        var utterances = [String]()

        let dialog = executeScript(script)
        dialog.subscribeNext {
            (object: AnyObject?) in
            let utterance = object! as String
            NSLog("Utterance: \(utterance)")
            utterances.append(utterance)
        }
        dialog.subscribeCompleted {
            // print(RACBacktrace())
            // trigger a context switch in order that we always get to the XCA_waitForStatus below before we call XCA_notify here
            dispatch_async(dispatch_get_main_queue()) {
                self.XCA_notify(XCTAsyncTestCaseStatus.Succeeded)
            }
        }

        XCA_waitForStatus(XCTAsyncTestCaseStatus.Succeeded, timeout: 0.1)
       
        var sometingWrong = utterances.count != expectedDialog.count
        XCTAssertEqual(utterances.count, expectedDialog.count, "The number of utterances in the exectued script is wrong")
        for index in 0 ... min(expectedDialog.count,utterances.count) - 1 {
            let actual: String = utterances[index]
            let expected: String = expectedDialog[index]
            sometingWrong |= actual != expected
            XCTAssertEqual(actual, expected, "The utterance is wrong")
        }

        if (sometingWrong) {
            NSLog("-------- DIALOG BEGIN ---------")
            for utterance in utterances {
                NSLog("Utterance: \(utterance)")
            }
            NSLog("-------- DIALOG END ---------")
        }
    }

    func randomizerWillChoose(forTag tag: RandomizerTags, index: Int) {
        _randomizer!.willChoose(forTag: tag, index: index)
    }

}