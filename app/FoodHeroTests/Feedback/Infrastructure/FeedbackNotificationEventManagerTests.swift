//
// Created by Jorg on 26/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class FeedbackNotificationEventManagerTests: XCTestCase {
    private var _appServiceSpy: ConversationAppServiceSpy!
    private var _appStub: UIApplicationStub!
    private var _mgr: FeedbackNotificationEventManager!
    private var _envStub: EnvironmentStub!

    override func setUp() {
        super.setUp()

        NSUserDefaults.removeAllPersistedDefaults()
        _appServiceSpy = ConversationAppServiceSpy()
        _envStub = EnvironmentStub()
        _appStub = UIApplicationStub(environment: _envStub)
        _mgr = FeedbackNotificationEventManager(appService: _appServiceSpy, app: _appStub, env: _envStub)
    }

    func scheduledLocalNotifications() -> [UILocalNotification] {
        return _appStub.scheduledLocalNotifications() as! [UILocalNotification]
    }

    func moveNowRelativeToNotificationFireDate(addedTime: NSTimeInterval) {
        if scheduledLocalNotifications().count > 0 {
            let notification = scheduledLocalNotifications()[0]
            let fireDate = notification.fireDate!
            let now = fireDate.dateByAddingTimeInterval(addedTime)
            _envStub.injectNow(now)
        }

        _appStub.removePassedNotifications()
    }

    func test_deactivate_ShouldScheduleNotification() {
        _mgr.deactivate()

        XCTAssert(scheduledLocalNotifications().count == 1)
        XCTAssertEqual(scheduledLocalNotifications()[0].userInfo as! [String:String], ["Type": "RequestUserFeedback"])
    }

    func test_deactivate_ShouldNotScheduleNotification_WhenProductFeedbackWasAlreadyRequested() {
        _mgr.deactivate()
        moveNowRelativeToNotificationFireDate(1)
        _mgr.activate()

        _mgr.deactivate()
        XCTAssert(scheduledLocalNotifications().count == 0, "No notification should have been created because the product feedback has been requested in activate() above")
    }

    func test_activate_SholdNotRequestProductFeedback_WhenProductFeedbackWasAlreadyRequested() {
        _mgr.deactivate()
        moveNowRelativeToNotificationFireDate(1)
        _mgr.activate()

        _mgr.deactivate()
        moveNowRelativeToNotificationFireDate(1)
        _mgr.activate()
        XCTAssertEqual(_appServiceSpy.NrCallsToStartWithFeedbackRequestFalse, 1, "2. time it should have been called without feedback request")
        XCTAssertEqual(_appServiceSpy.NrCallsToStartWithFeedbackRequestTrue, 1, "1. time it should have been called with feedback request")
    }

    func test_activate_ShouldCancelNotification() {
        _mgr.deactivate()
        _mgr.activate()

        let notifications = _appStub.scheduledLocalNotifications() as! [UILocalNotification]
        XCTAssert(notifications.count == 0)
    }

    func test_activate_ShouldClearApplicationIconBadgeNumber() {
        _appStub.applicationIconBadgeNumber = 1

        _mgr.activate()

        XCTAssertEqual(_appStub.applicationIconBadgeNumber, 0)
    }

    func test_activate_ShouldRequestProductFeedback_WhenTimeForFeedbackPassed() {
        _mgr.deactivate()

        moveNowRelativeToNotificationFireDate(1)

        _mgr.activate()

        XCTAssertEqual(_appServiceSpy.NrCallsToStartWithFeedbackRequestTrue, 1, "it should have been called with feedback request")
        XCTAssertEqual(_appServiceSpy.NrCallsToStartWithFeedbackRequestFalse, 0, "it should have been called with feedback request")
    }

    func test_activate_ShouldNotRequestProductFeedback_TimeForFeedbackHasNotPassed() {
        _mgr.deactivate()

        moveNowRelativeToNotificationFireDate(-1)

        _mgr.activate()

        XCTAssertEqual(_appServiceSpy.NrCallsToStartWithFeedbackRequestTrue, 0, "it should have been called without feedback request")
        XCTAssertEqual(_appServiceSpy.NrCallsToStartWithFeedbackRequestFalse, 1, "it should have been called without feedback request")
    }

    func test_activate_ShouldNotRequestProductFeedback_WhenItHasNotBeenDeactivated() {
        _mgr.activate()

        XCTAssertEqual(_appServiceSpy.NrCallsToStartWithFeedbackRequestTrue, 0, "it should have been called without feedback request")
        XCTAssertEqual(_appServiceSpy.NrCallsToStartWithFeedbackRequestFalse, 1, "it should have been called without feedback request")
    }


}
