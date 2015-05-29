//
// Created by Jorg on 17/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class OccasionToGoogleTypeMapperTests: XCTestCase {

    func test_map_shouldMapCorrectly_WhenBreakfast() {
        var types = OccasionToGoogleTypeMapper.map(Occasions.breakfast())

        XCTAssertEqual(count(types), 2)
        XCTAssertEqual(types[0], "bakery")
        XCTAssertEqual(types[1], "cafe")
    }

    func test_map_shouldMapCorrectly_WhenLunch() {
        var types = OccasionToGoogleTypeMapper.map(Occasions.lunch())

        XCTAssertEqual(count(types), 3)
        XCTAssertEqual(types[0], "restaurant")
        XCTAssertEqual(types[1], "meal_takeaway")
        XCTAssertEqual(types[2], "meal_delivery")
    }

    func test_map_shouldMapCorrectly_WhenSnack() {
        var types = OccasionToGoogleTypeMapper.map(Occasions.snack())

        XCTAssertEqual(count(types), 1)
        XCTAssertEqual(types[0], "cafe")
    }

    func test_map_shouldMapCorrectly_WhenDinner() {
        var types = OccasionToGoogleTypeMapper.map(Occasions.dinner())

        XCTAssertEqual(count(types), 3)
        XCTAssertEqual(types[0], "restaurant")
        XCTAssertEqual(types[1], "meal_takeaway")
        XCTAssertEqual(types[2], "meal_delivery")
    }

    func test_map_shouldMapCorrectly_WhenDrinks() {

        var types = OccasionToGoogleTypeMapper.map(Occasions.drink())

        XCTAssertEqual(count(types), 2)
        XCTAssertEqual(types[0], "bar")
        XCTAssertEqual(types[1], "night_club")
    }

    func test_map_shouldMapCorrectly_WhenEmpty() {
        var types = OccasionToGoogleTypeMapper.map("")

        XCTAssertTrue(contains(types, "bakery"))
        XCTAssertTrue(contains(types, "cafe"))
        XCTAssertTrue(contains(types, "restaurant"))
        XCTAssertTrue(contains(types, "meal_takeaway"))
        XCTAssertTrue(contains(types, "meal_delivery"))
        XCTAssertTrue(contains(types, "bar"))
        XCTAssertTrue(contains(types, "bakery"))
        XCTAssertTrue(contains(types, "night_club"))
    }
}
