//
// Created by Jorg on 10/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

extension NSCalendar {

    public class func dateFrom(year year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> NSDate {
        let component = NSDateComponents()
        component.year = year
        component.month = month
        component.day = day
        component.hour = hour
        component.minute = minute
        component.second = second

        return  NSCalendar.currentCalendar().dateFromComponents(component)!
    }
}
