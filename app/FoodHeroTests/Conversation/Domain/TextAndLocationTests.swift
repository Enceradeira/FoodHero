//
// Created by Jorg on 29/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class TextAndLocationTests: XCTestCase {

    func test_equalsShouldReturnTrue_WhenEqual() {
        XCTAssertEqual(TextAndLocation(text: "", location: ""), TextAndLocation(text: "", location: ""))
        XCTAssertEqual(TextAndLocation(text: "", location: ""), TextAndLocation(text: "", location: ""))
        XCTAssertEqual(TextAndLocation(text: "", location: nil), TextAndLocation(text: "", location: ""))
        XCTAssertEqual(TextAndLocation(text: "", location: nil), TextAndLocation(text: "", location: ""))
        XCTAssertEqual(TextAndLocation(text: "French", location: "Norwich"), TextAndLocation(text: "French", location: "Norwich"))
    }

    func test_equalsShouldReturnFalse_WhenNotEqual() {
        XCTAssertNotEqual(TextAndLocation(text: "French", location: "Norwich"), TextAndLocation(text: "French", location: "York"))
        XCTAssertNotEqual(TextAndLocation(text: "Italian", location: "Norwich"), TextAndLocation(text: "Indian", location: "Norwich"))
    }
}
