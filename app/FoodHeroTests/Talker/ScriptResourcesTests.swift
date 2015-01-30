//
// Created by Jorg on 29/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ScriptResourcesTests: XCTestCase {

    var _randomizer: TalkerRandomizerFake?

    override func setUp() {
        super.setUp()

        _randomizer = TalkerRandomizerFake()
    }

    func randomizerWillChoose(forTag tag: RandomizerTags, #index: Int) {
        _randomizer!.willChoose(forTag: tag, index: index)
    }

    func test_resolve_ShouldResolveTextParameterRandomly() {
        let resources = ScriptResources(_randomizer!)
        resources.add(parameter: "name", withValues: ["Ann", "Peter", "Maria"])

        randomizerWillChoose(forTag: RandomizerTags.TextParameters, index: 2)
        let result = resources.resolve("Hi I'm {name}")

        XCTAssertEqual(result, "Hi I'm Maria")
    }

    func test_resolve_ShouldResolveSameTextParametersTwice() {
        let resources = ScriptResources(_randomizer!)
        resources.add(parameter: "name", withValues: ["Ann"])

        let result = resources.resolve("{name} is {name}")

        XCTAssertEqual(result, "Ann is Ann")
    }

    func test_resolve_ShouldResolveTowDifferentTextParameters() {
        let resources = ScriptResources(_randomizer!)
        resources.add(parameter: "surname", withValues: ["Boleyn"])
        resources.add(parameter: "name", withValues: ["Ann"])

        let result = resources.resolve("I'm {name} {surname}")

        XCTAssertEqual(result, "I'm Ann Boleyn")
    }

    func test_resolve_ShouldHandleInvalidMarkup() {
        let resources = ScriptResources(_randomizer!)
        resources.add(parameter: "name", withValues: ["Ann"])

        let result = resources.resolve("I'm {{name}")

        XCTAssertEqual(result, "I'm {Ann")
    }
}
