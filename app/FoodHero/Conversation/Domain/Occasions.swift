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
        return "snacks"
    }

    public class func dinner() -> String {
        return "dinner"
    }

    public class func drink() -> String {
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
            return drink()
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
        return drink()
    }

    private class func getOccasionForWeekend(now: NSDate) -> String {
        if now.compare(compontens(hour: 4, minute: 59)) == .OrderedAscending {
            return drink()
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
        return drink()
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

    public class func guessFromCuisine(cuisine: String) -> String {
        let normalizedCuisine = removeCharacterAtTheEndOfAString("s", string: cuisine.lowercaseString
        .stringByReplacingOccurrencesOfString(" ", withString: "")
        .stringByReplacingOccurrencesOfString("'", withString: ""))

        /* NOTE when adding new mappings:
            - Remove Space and Apostroph
            - Remove trailing s (even it's not plural)
        */

        switch normalizedCuisine {
        case "":
            return ""
        case "beer", "wine", "ale":
            return drink()
        case "tea", "cafe", "coffee", "cake", "starbuck":
            return snack()
        case "bread", "breakfast", "fry-up", "fry up":
            return breakfast()
        case "pizza", "burger", "bbq", "hamburger", "kebab", "fastfood", "macdonald", "burgerking", "wedding", "weddingreception", "reception":
            return dinner()
        default:
            NSLog("Occasions.guessFromCuisine: no occasion guessed for \(cuisine)")
            return ""
        }
    }

    private class func removeCharacterAtTheEndOfAString(character: Character, string: String) -> String {
        let len = count(string)
        if len < 1 {
            return string
        }

        let idx = advance(string.endIndex,-1)
        if string[idx] == character {
            return string.substringToIndex(idx)
        } else {
            return string
        }
    }
}
