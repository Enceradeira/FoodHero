//
// Created by Jorg on 26/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class UIApplicationStub: NSObject, IUIApplication {
    private var _notifications: [UILocalNotification] = []
    private let _environment: IEnvironment
    public var applicationIconBadgeNumber: Int = 0

    public init(environment: IEnvironment) {
        _environment = environment
    }

    public func scheduledLocalNotifications() -> [AnyObject]! {
        return _notifications;
    }

    public func scheduleLocalNotification(notification: UILocalNotification) {
        _notifications.append(notification)
    }

    public func cancelAllLocalNotifications() {
        _notifications.removeAll()
    }

    public func removePassedNotifications() {
        _notifications = _notifications.filter {
            (n: UILocalNotification) in
            return (n.fireDate!.compare(self._environment.now()) == .OrderedDescending)
        }
    }
}
