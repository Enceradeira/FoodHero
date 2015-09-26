//
// Created by Jorg on 26/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class UIApplicationAdapter: NSObject, IUIApplication {
    private let _uiApplication: UIApplication
    public init(app: UIApplication) {
        _uiApplication = app
    }

    public func scheduledLocalNotifications() -> [AnyObject]! {
        return _uiApplication.scheduledLocalNotifications;
    }

    public func scheduleLocalNotification(notification: UILocalNotification) {
        _uiApplication.scheduleLocalNotification(notification)
    }

    public func cancelAllLocalNotifications() {
        _uiApplication.cancelAllLocalNotifications()
    }

    public var applicationIconBadgeNumber: Int {
        set(number) {
            _uiApplication.applicationIconBadgeNumber = number
        }
        get {
            return _uiApplication.applicationIconBadgeNumber
        }
    }
}
