//
// Created by Jorg on 10/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class OccasionsTests: XCTestCase {
    var env: EnvironmentStub!

    override func setUp() -> () {
        let assembly = StubAssembly()
        TyphoonComponents.configure(assembly)
        env = assembly.environment() as! EnvironmentStub
    }

    func assertOccassionAt(# year: Int, month: Int, day: Int, hour: Int, minute: Int, expected: String) {
        let time = NSCalendar.dateFrom(year: year, month: month, day: day, hour: hour, minute: minute, second: 15)
        env!.injectNow(time)
        let occasion = Occasions.getCurrent(env!)
        XCTAssertEqual(occasion, expected)
    }

    func test_getCurrent_ShouldReturnCorrectOccasion_WhenWeekday() {
        /*  0:00 - 4:59  drinks */
        /*  5:00 - 9:59  breakfast */
        /* 10:00 - 11:59 snack */
        /* 12:00 - 13:59 lunch */
        /* 14:00 - 17:29 snack */
        /* 17:30 - 21:59 dinner */
        /* 22:00 - 23:59 drinks */

        for day in 23 ... 27 {
            // 23 - 27/3/2015 are weekdays
            // assuming people start searching 15 min before begin of occasion
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 0, minute: 0, expected: Occasions.drink())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 4, minute: 44, expected: Occasions.drink())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 4, minute: 45, expected: Occasions.breakfast())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 9, minute: 44, expected: Occasions.breakfast())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 9, minute: 45, expected: Occasions.snack())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 11, minute: 44, expected: Occasions.snack())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 11, minute: 45, expected: Occasions.lunch())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 13, minute: 44, expected: Occasions.lunch())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 13, minute: 45, expected: Occasions.snack())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 17, minute: 14, expected: Occasions.snack())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 17, minute: 15, expected: Occasions.dinner())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 21, minute: 44, expected: Occasions.dinner())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 21, minute: 45, expected: Occasions.drink())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 23, minute: 59, expected: Occasions.drink())
        }

    }

    func test_getCurrent_ShouldReturnCorrectOccasion_WhenWeekend() {
        /*  0:00 - 4:59  drinks */
        /*  5:00 - 10:59  breakfast */
        /* 11:00 - 11:59 snack */
        /* 12:00 - 14:59 lunch */
        /* 15:00 - 17:29 snack */
        /* 17:30 - 21:59 dinner */
        /* 22:00 - 23:59 drinks */

        for day in 28 ... 29 {
            // 28 - 29/3/2015 are weekend days
            // assuming people start searching 15 min before begin of occasion
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 0, minute: 0, expected: Occasions.drink())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 4, minute: 44, expected: Occasions.drink())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 4, minute: 45, expected: Occasions.breakfast())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 10, minute: 44, expected: Occasions.breakfast())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 10, minute: 45, expected: Occasions.snack())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 11, minute: 44, expected: Occasions.snack())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 11, minute: 45, expected: Occasions.lunch())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 14, minute: 44, expected: Occasions.lunch())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 14, minute: 45, expected: Occasions.snack())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 17, minute: 14, expected: Occasions.snack())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 17, minute: 15, expected: Occasions.dinner())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 21, minute: 44, expected: Occasions.dinner())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 21, minute: 45, expected: Occasions.drink())
            assertOccassionAt(year: 2015, month: 3, day: day, hour: 23, minute: 59, expected: Occasions.drink())
        }
    }

    func test_guessFromCuisine_ShouldProcessUpperAndLowerCase(){
        XCTAssertEqual(Occasions.guessFromCuisine("beer"), Occasions.drink())
        XCTAssertEqual(Occasions.guessFromCuisine("Beer"), Occasions.drink())
        XCTAssertEqual(Occasions.guessFromCuisine("BEER"), Occasions.drink())
    }

    func test_guessFromCuisine_ShouldProcessPluralAndSingular(){
        XCTAssertEqual(Occasions.guessFromCuisine("beer"), Occasions.drink())
        XCTAssertEqual(Occasions.guessFromCuisine("beers"), Occasions.drink())
    }

    func test_guessFromCuisine_ShouldIngoreApostroph(){
        XCTAssertEqual(Occasions.guessFromCuisine("Mac Donalds"), Occasions.dinner())
        XCTAssertEqual(Occasions.guessFromCuisine("Mac Donald's"), Occasions.dinner())
    }

    func test_guessFromCuisine_ShouldIgnoreWhiteSpace(){
        XCTAssertEqual(Occasions.guessFromCuisine("hamburger"), Occasions.dinner())
        XCTAssertEqual(Occasions.guessFromCuisine("ham burger"), Occasions.dinner())
    }

    func test_guessFromCuisine_ShouldReturnEmtpy_WhenCuisineEmpty(){
        XCTAssertEqual(Occasions.guessFromCuisine(""), "")
    }
}
