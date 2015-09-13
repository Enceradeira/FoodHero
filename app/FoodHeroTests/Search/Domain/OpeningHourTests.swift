//
// Created by Jorg on 12/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class OpeningHourTests: XCTestCase {
    func test_encodeDecode_ShouldRestoreObject() {
        let openingHour = OpeningHour(day: "monday", hours: "1am - 2pm", isToday: true)

        let decodedOpeningHour = CodingHelper.encodeAndDecode(openingHour)
        XCTAssertEqual(decodedOpeningHour, openingHour)
    }
}
