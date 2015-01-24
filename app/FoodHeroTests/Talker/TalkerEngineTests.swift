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

    func talkUsing(script: Script) -> RACSignal {
        return TalkerEngine(script).talk()
    }

    public func test_talk_shouldSaySomething() {
        let dialog = talkUsing(Script().Say("Hello"));

        let result = (dialog.toArray() as [String])[0]

        XCTAssertEqual(result, "Hello")
    }

    public func test_talk_shouldComplete_WhenNothingIsToBeSaid() {
        let dialog = talkUsing(Script());

        let hasCompleted = dialog.asynchronouslyWaitUntilCompleted(nil)

        XCTAssertEqual(hasCompleted, true)
    }

    public func test_talk_shouldComplete_WhenEverythingHasBeenSaid() {
        let dialog = talkUsing(Script().Say("Hello").Say("World"));

        let hasCompleted = dialog.asynchronouslyWaitUntilCompleted(nil)

        XCTAssertEqual(hasCompleted, true)
    }

}