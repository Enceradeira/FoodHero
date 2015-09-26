//
// Created by Jorg on 26/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class FeedbackNotificationEventManager: NSObject {
    private let _appService: IConversationAppService
    private let _app: IUIApplication
    private let _env: IEnvironment
    private let _userDefaultsFireDateKey = "ProductFeedbackNotificationFireDate"
    private let _userDefaultsProductFeedbackRequestedKey = "ProductFeedbackRequested"
    private let _userDefaults: NSUserDefaults
    public init(appService: IConversationAppService, app: IUIApplication, env: IEnvironment) {
        _appService = appService
        _app = app
        _env = env
        _userDefaults = NSUserDefaults.standardUserDefaults()
    }

    private var wasProductFeedbackRequested: Bool {
        get {
            if let wasRequested = _userDefaults.boolForKey(_userDefaultsProductFeedbackRequestedKey) as? Bool {
                return wasRequested
            }
            return false
        }
    }

    public func activate() {
        _app.cancelAllLocalNotifications()
        _app.applicationIconBadgeNumber = 0

        var startWithProductFeedback = false
        if wasProductFeedbackRequested {
            startWithProductFeedback = false
        } else if let fireDate = _userDefaults.objectForKey(_userDefaultsFireDateKey) as! NSDate? {
            if fireDate.compare(_env.now()) == .OrderedAscending {
                startWithProductFeedback = true
                _userDefaults.setBool(true, forKey: _userDefaultsProductFeedbackRequestedKey)
            }
        }
        _appService.startWithFeedbackRequest(startWithProductFeedback)
    }


    public func deactivate() {
        if wasProductFeedbackRequested {
            return
        }


        let feedbackNotification = NotificationBuilder.buildRequestUserFeedbackNotification()

        _userDefaults.setObject(feedbackNotification.fireDate!, forKey: _userDefaultsFireDateKey)

        _app.scheduleLocalNotification(feedbackNotification)
    }
}
