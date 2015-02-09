//
// Created by Jorg on 09/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

public class TalkerUtteranceTests: XCTestCase {
    func test_concat_ShouldJoinUtteranceTogether() {
        let utterance1 = TalkerUtterance(utterance: "Hello")
        let utternace2 = TalkerUtterance(utterance: "World")

        let utterance = utterance1.concat(utternace2)

        XCTAssertEqual(utterance.utterance, "Hello\n\nWorld")
    }

    func test_concat_ShouldJoinUtteranceTogether_WhenFirstUtteranceIsEmpty() {
        let utterance1 = TalkerUtterance()
        let utternace2 = TalkerUtterance(utterance: "World")

        let utterance = utterance1.concat(utternace2)

        XCTAssertEqual(utterance.utterance, "World")
    }

    func test_concat_ShouldJoinUtteranceTogether_WhenSecondUtteranceIsEmpty() {
        let utterance1 = TalkerUtterance(utterance: "Hello")
        let utternace2 = TalkerUtterance()

        let utterance = utterance1.concat(utternace2)

        XCTAssertEqual(utterance.utterance, "Hello")
    }

    func test_concat_ShouldJoinUtteranceTogether_WhenBothUtterancesAreEmpty() {
        let utterance1 = TalkerUtterance()
        let utternace2 = TalkerUtterance()

        let utterance = utterance1.concat(utternace2)

        XCTAssertEqual(utterance.utterance, "")
    }

    func test_concat_ShouldJoinCustomDataTogether_WhenOneCustomDataIsNil() {
        let utterance1 = TalkerUtterance(utterance: "Hello", customData: nil)
        let utternace2 = TalkerUtterance(utterance: "World", customData: "SomeData")

        let utterance = utterance1.concat(utternace2)

        let customData = utterance.customData
        XCTAssertEqual(customData.count, 1)
        XCTAssertEqual(customData[0] as String, "SomeData")
    }

    func test_concat_ShouldJoinCustomDataTogether_WhenOneCustomDataIsNOtNil() {
        let utterance1 = TalkerUtterance(utterance: "Hello", customData: "SomeData")
        let utternace2 = TalkerUtterance(utterance: "World", customData: "OtherData")

        let utterance = utterance1.concat(utternace2)

        let customData = utterance.customData
        XCTAssertEqual(customData.count, 2)
        XCTAssertEqual(customData[0] as String, "SomeData")
        XCTAssertEqual(customData[1] as String, "OtherData")
    }
}
