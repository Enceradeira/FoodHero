//
// Created by Jorg on 25/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class NotificationBuilder: NSObject {

    public class func registerUserNotificationSettings(app: UIApplication) {
        let settings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge], categories: nil)
        app.registerUserNotificationSettings(settings)
    }

    public class func buildRequestUserFeedbackNotification() -> UILocalNotification {
        let now = NSDate()
        let hoursAfterNine = Int(arc4random_uniform(13))
        let nowComponents = NSCalendar.currentCalendar().components([.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit, .NSHourCalendarUnit, .NSMinuteCalendarUnit, .NSSecondCalendarUnit], fromDate: now);
        let tomorrowBetween9AmAnd9Pm = NSCalendar.dateFrom(year: nowComponents.year, month: nowComponents.month, day: nowComponents.day + 1, hour: 9 + hoursAfterNine, minute: 0, second: 0)
        // let tomorrowBetween9AmAnd9Pm = NSCalendar.dateFrom(year: nowComponents.year, month: nowComponents.month, day: nowComponents.day, hour: nowComponents.hour, minute: nowComponents.minute, second: nowComponents.second+5)

        let notification = UILocalNotification()
        notification.fireDate = tomorrowBetween9AmAnd9Pm
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "Food Hero has sent you a message"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.applicationIconBadgeNumber = 1
        notification.userInfo = ["Type": "RequestUserFeedback"]
        return notification
    }
}
