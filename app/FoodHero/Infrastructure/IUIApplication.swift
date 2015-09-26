//
// Created by Jorg on 26/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

@objc
public protocol IUIApplication {
    func scheduledLocalNotifications() -> [AnyObject]!

    func scheduleLocalNotification(notification: UILocalNotification)

    func cancelAllLocalNotifications()

    var applicationIconBadgeNumber: Int { set get }
}

