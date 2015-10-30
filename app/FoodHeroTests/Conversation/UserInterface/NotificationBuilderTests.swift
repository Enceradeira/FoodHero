//
// Created by Jorg on 25/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class NotificationBuilderTests: XCTestCase {
    internal func test_buildRequestUserFeedbackNotification_ShouldScheduleNotification() {
        let now = NSDate()
        let nowComponents = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: now);

        let tomorrowNineAm = NSCalendar.dateFrom(year: nowComponents.year, month: nowComponents.month, day: nowComponents.day + 1, hour: 9, minute: 0, second: 0)
        let tomorrowNinePm = NSCalendar.dateFrom(year: nowComponents.year, month: nowComponents.month, day: nowComponents.day + 1, hour: 21, minute: 0, second: 0)

        // check many time because the result is random
        for _ in 1 ... 50 {
            let notification = NotificationBuilder.buildRequestUserFeedbackNotification()

            let compareNineAM = notification.fireDate!.compare(tomorrowNineAm)
            XCTAssertTrue(compareNineAM == .OrderedDescending || compareNineAM == .OrderedSame, "notification must fire tomorrow on or after 9 a.m" )

            let compareNinePM = notification.fireDate!.compare(tomorrowNinePm)
            XCTAssertTrue(compareNinePM == .OrderedAscending || compareNinePM == .OrderedSame, "notification must fire tomorrow on or before 9 p.m" )
        }
    }
}
