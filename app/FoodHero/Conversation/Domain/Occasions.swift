//
// Created by Jorg on 10/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class Occasions: NSObject {
    static let offset = -900.0

    public class func breakfast() -> String {
        return "breakfast"
    }

    public class func lunch() -> String {
        return "lunch"
    }

    public class func snack() -> String {
        return "snack"
    }

    public class func dinner() -> String {
        return "dinner"
    }

    public class func drinks() -> String {
        return "drinks"
    }

    public class func getCurrent(env: IEnvironment) -> String {
        let now = getNowFromComponents(env)
        switch getDayOfWeek(env) {
        case 1, 7:
            return getOccasionForWeekend(now)
        default:
            return getOccasionForWeekdays(now)
        }
    }

    private class func getCalendar() -> NSCalendar {
        return NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    }

    private class func getOccasionForWeekdays(now: NSDate) -> String {
        if now.compare(compontens(hour: 4, minute: 59)) == .OrderedAscending {
            return drinks()
        }
        if now.compare(compontens(hour: 9, minute: 59)) == .OrderedAscending {
            return breakfast()
        }
        if now.compare(compontens(hour: 11, minute: 59)) == .OrderedAscending {
            return snack()
        }
        if now.compare(compontens(hour: 13, minute: 59)) == .OrderedAscending {
            return lunch()
        }
        if now.compare(compontens(hour: 17, minute: 29)) == .OrderedAscending {
            return snack()
        }
        if now.compare(compontens(hour: 21, minute: 59)) == .OrderedAscending {
            return dinner()
        }
        return drinks()
    }

    private class func getOccasionForWeekend(now: NSDate) -> String {
        if now.compare(compontens(hour: 4, minute: 59)) == .OrderedAscending {
            return drinks()
        }
        if now.compare(compontens(hour: 10, minute: 59)) == .OrderedAscending {
            return breakfast()
        }
        if now.compare(compontens(hour: 11, minute: 59)) == .OrderedAscending {
            return snack()
        }
        if now.compare(compontens(hour: 14, minute: 59)) == .OrderedAscending {
            return lunch()
        }
        if now.compare(compontens(hour: 17, minute: 29)) == .OrderedAscending {
            return snack()
        }
        if now.compare(compontens(hour: 21, minute: 59)) == .OrderedAscending {
            return dinner()
        }
        return drinks()
    }

    private class func getNowFromComponents(env: IEnvironment) -> NSDate {
        let calendar = getCalendar()
        let nowComponents = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: env.now())
        return calendar.dateFromComponents(nowComponents)!

    }

    private class func compontens(# hour: Int, minute: Int) -> NSDate {
        let component = NSDateComponents();
        component.hour = hour
        component.minute = minute
        component.second = 59
        let calendar = getCalendar()
        let dateWithOffset = calendar.dateFromComponents(component)!
        let date = dateWithOffset.dateByAddingTimeInterval(offset)
        return date
    }

    private class func getDayOfWeek(env: IEnvironment) -> Int {
        let calendar = getCalendar()
        let components = calendar.components(.CalendarUnitWeekday, fromDate: env.now())
        return components.weekday
    }
}
