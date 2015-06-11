//
// Created by Jorg on 11/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

import Foundation
import FoodHero

class GAIServiceTests: XCTestCase {
    func test_configure_shouldNeverConfigureGAIOnSimulator() {
        let result = GAIService.configure()
        XCTAssertEqual(result, false)
    }

}