//
// Created by Jorg on 25/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import XCTest
import FoodHero

class ConfigurationTests: XCTestCase {
    func test_environment_shouldBeIntegration_WhenRunningInXCTestRunner() {
        let env = Configuration.environment()
        XCTAssertEqual(env, "Integration")
    }

    func test_simulateSlowness_shouldBeFalse_WhenRunningInXCTestRunner() {
        XCTAssertEqual(Configuration.simulateSlowness(), false)
    }

    func test_parseEnvironment_ShouldReturnProduction_WhenNoEnvironmentSpecified() {
        XCTAssertEqual(Configuration.parseEnvironment([]), "Production")
    }

    func test_parseEnvironment_ShouldReturnDevelopment_WhenDevelopmentSpecified() {
        XCTAssertEqual(Configuration.parseEnvironment(["-environment=Development"]), "Development")
    }

    func test_parseSimulateSlowness_ShouldReturnTrue_WhenTrue() {
        XCTAssertEqual(Configuration.parseSimulateSlowness(["-simulateSlowness=true"]), true)
        XCTAssertEqual(Configuration.parseSimulateSlowness(["-simulateSlowness=TRUE"]), true)
    }

    func test_parseSImulateSlowness_ShouldReturnFalse_WhenFalse() {
        XCTAssertEqual(Configuration.parseSimulateSlowness(["-simulateSlowness=false", "-environment=Development"]), false)
    }

    func test_parseSImulateSlowness_ShouldReturnFalse_WhenNotPresent() {
        XCTAssertEqual(Configuration.parseSimulateSlowness(["-environment=Development"]), false)
    }
}
