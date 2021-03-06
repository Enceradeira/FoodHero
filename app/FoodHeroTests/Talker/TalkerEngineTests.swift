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
    var _randomizer: TalkerRandomizerFake?

    public override func setUp() {
        super.setUp()

        _input = RACSubject()
        _randomizer = TalkerRandomizerFake()
    }

    public func async(closure: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            closure()
        }
    }

    func TestScript(resources: ScriptResources? = nil) -> Script {
        let resolvedResources = resources ?? ScriptResources(randomizer: _randomizer!)
        let context = TalkerContext(randomizer: _randomizer!, resources: resolvedResources)
        return Script(talkerContext: context)
    }

    func TestScriptResources() -> ScriptResources {
        return ScriptResources(randomizer: _randomizer!)
    }

    func executeScript(script: Script, var onEngine engine: TalkerEngine? = nil, withNaturalOutput naturalOutput: Bool = true) -> RACSignal {
        if (engine == nil) {
            engine = TalkerEngine(input: _input!)
        }
        engine!.execute(script)
        let stream = engine!.output
        if (naturalOutput) {
            return stream.naturalOutput
        } else {
            return stream.rawOutput
        }
    }

    func executeDialogFor(script: Script) -> [String] {
        let dialog = executeScript(script, onEngine: TalkerEngine(input: _input!))
        return (dialog.toArray() as! [String])
    }

    func assert(utterance utterance: String, exists: Bool, inExecutedScript script: Script, atPosition expectedPosition: Int? = nil, withNaturalOutput naturalOutput: Bool = true) {
        let engine = TalkerEngine(input: _input!)
        assert(utterance: utterance, exists: exists, inDialog: executeScript(script, onEngine: engine, withNaturalOutput: naturalOutput), atPosition: expectedPosition)
    }

    func assert(utterance utterance: String, exists: Bool, inDialog dialog: RACSignal, atPosition expectedPosition: Int? = nil) {
        var positionCount: Int = 0
        var actualPosition: Int? = nil
        var error: NSError? = nil
        var utterances: [String] = []

        let signal = dialog.map {
            (object: AnyObject?) in
            let utterance = (object! as! TalkerUtterance).utterance
            NSLog("Utterance: \(utterance)")
            return GenericWrapper(text: utterance, position: positionCount++)
        }.filter {
            (object: AnyObject?) in
            let tuple = (object as! GenericWrapper<(text:String, position:Int)>)
            return tuple.element.text == utterance
        }

        signal.subscribeNext {
            (object: AnyObject?) in
            let tuple = (object as! GenericWrapper<(text:String, position:Int)>)
            utterances.append(tuple.element.text)
            if (actualPosition == nil) {
                actualPosition = tuple.element.position
            }

            // trigger a context switch in order that we always get to the XCA_waitForStatus below before we call XCA_notify here
            dispatch_async(dispatch_get_main_queue()) {
                self.XCA_notify(exists ? XCTAsyncTestCaseStatus.Succeeded : XCTAsyncTestCaseStatus.Failed)
            }
        }

        signal.doError {
            e in error = e
        }


        let timeoutUSeconds: UInt32 = 2000 /*2000 ms*/ * 1000;
        if (!exists) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let waitBeforeTimeoutPreventedUSeconds = timeoutUSeconds * 8 / 10
                usleep(waitBeforeTimeoutPreventedUSeconds)  // just before the timeout arises Succeeded is signaled to end the wait for the not existing element
                self.XCA_notify(XCTAsyncTestCaseStatus.Succeeded)
            }
        }
        let timeoutSeconds = NSTimeInterval(Float(timeoutUSeconds) / 1000000)
        XCA_waitForStatus(XCTAsyncTestCaseStatus.Succeeded, timeout: timeoutSeconds)

        XCTAssertNil(error, "there was an error thrown")

        if (expectedPosition != nil) {
            XCTAssertEqual(actualPosition ?? (-1), expectedPosition!, "Utterance is at wrong position")
        }
    }

    func sendInput(utterance: Any, _ customData: AnyObject? = nil) {
        // force context switch because that's closer to reality
        dispatch_async(dispatch_get_main_queue()) {
            if utterance is String {
                self._input!.sendNext(TalkerUtterance(utterance: utterance as! String, customData: customData))
            } else if utterance is NSError {
                let error = utterance as! NSError
                self._input!.sendNext(error)
            }
        }
    }

    func assert(dialog expectedDialog: [NSString], forExecutedScript script: Script, withNaturalOutput naturalOutput: Bool = true, whenInputIs generator: (String, TalkerEngine) -> (Any?) = {
        g in return nil
    }) {
        var utterances = [String]()

        let engine = TalkerEngine(input: _input!)
        let dialog = executeScript(script, onEngine: engine, withNaturalOutput: naturalOutput)

        // see if input is to be generated befor scipt is subscribed (evaluated)
        let initialInput = generator("", engine)
        if initialInput != nil {
            sendInput(initialInput!, nil)
        }

        // subscribe to output and collect utterances until completed
        dialog.subscribeNext({
            // collect utterances
            (object: AnyObject?) in
            let utterance = (object! as! TalkerUtterance).utterance
            NSLog("Utterance: \(utterance)")
            utterances.append(utterance)

            // generate input from utterance
            let response = generator(utterance, engine)
            if response != nil {
                self.sendInput(response!, nil)
            }

        },
                completed: {
                    // trigger a context switch in order that we always get to the XCA_waitForStatus below before we call XCA_notify here
                    dispatch_async(dispatch_get_main_queue()) {
                        self.XCA_notify(XCTAsyncTestCaseStatus.Succeeded)
                    }
                })

        // wait for completion
        XCA_waitForStatus(XCTAsyncTestCaseStatus.Succeeded, timeout: 1.0)


        // check collected utterances
        var sometingWrong = utterances.count != expectedDialog.count
        XCTAssertEqual(utterances.count, expectedDialog.count, "The number of utterances in the exectued script is wrong")
        for index in 0 ... min(expectedDialog.count, utterances.count) - 1 {
            let actual: String = utterances[index]
            let expected: String = expectedDialog[index] as String
            sometingWrong = sometingWrong || actual != expected
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

    func randomizerWillChoose(forTag tag: String, index: Int) {
        _randomizer!.willChoose(forTag: tag, index: index)
    }

    func randomizerWillChoose(forTag tag: String, value: Bool) {
        _randomizer!.willChoose(forTag: tag, value: value)
    }

}