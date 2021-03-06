//
// Created by Jorg on 27/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class TalkerRandomizerTests: XCTestCase {

    var _randomizer: TalkerRandomizer?

    override func setUp() {
        super.setUp()

        _randomizer = TalkerRandomizer()
    }

    func test_chooseOne_ShouldChooseAStringRandomly() {
        let string1 = "A"
        let string2 = "B"
        let choices = [string1, string2]

        let nrTests = 10
        var nrString1 = 0;
        var nrString2 = 0;

        for _ in 1 ... nrTests {
            let choice = _randomizer!.chooseOne(from: choices, forTag: RandomizerConstants.texts()) as! String
            if (choice == string1) {
                nrString1++
            }
            if (choice == string2) {
                nrString2++
            }
        }

        XCTAssertGreaterThan(nrString1, 0)
        XCTAssertGreaterThan(nrString2, 0)
        XCTAssertEqual(nrString1 + nrString2, nrTests)
    }

    func test_isTrue_ShouldChooseTrueAndFalseRandomly() {
        let nrTests = 10
        var nrTrue = 0

        for _ in 1 ... nrTests {
            if _randomizer!.isTrue(forTag:RandomizerConstants.texts())   {
                nrTrue++
            }
        }

        XCTAssertGreaterThan(nrTrue, 0)
        XCTAssertLessThan(nrTrue, nrTests)
    }
}
