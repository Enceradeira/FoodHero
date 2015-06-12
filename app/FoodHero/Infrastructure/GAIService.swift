//
// Created by Jorg on 10/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class GAIService: NSObject {
    private static var _tracker: GAITracker! = nil

    public class func configure() -> Bool {
        if UIDevice.currentDevice().model.rangeOfString("Simulator") != nil {
            return false
        }

        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().logger.logLevel = GAILogLevel.Verbose
        GAI.sharedInstance().dispatchInterval = 60
        _tracker = GAI.sharedInstance().trackerWithTrackingId("UA-25686837-2")

        let version = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
        let shortVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString" as String) as! String

        _tracker.set(kGAIAppVersion, value: "\(shortVersion).\(version)")
        _tracker.set("&uid", value: UserId.id())
        return true
    }

    private class var gaiInactive: Bool{
        get{
            return _tracker == nil
        }
    }

    public class func logScreenViewed(screenName: String) {
        if (gaiInactive) {
            return;
        }
        _tracker.set(kGAIScreenName, value: screenName)
        _tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject:AnyObject])
    }

    public class func logEventWithCategory(category: String, action: String, label: String, value: Float) {
        if (gaiInactive) {
            return;
        }
        let event = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build();
        _tracker.send(event as [NSObject:AnyObject])

    }

    public class func logTimingWithCategory(category: String, name: String, label: String, interval: NSTimeInterval) {
        if (gaiInactive) {
            return;
        }
        let timing = GAIDictionaryBuilder.createTimingWithCategory(category, interval: interval * 1000, name: name, label: label).build();
        _tracker.send(timing as [NSObject:AnyObject])
    }

    public class func dispatch() {
        if (gaiInactive) {
            return;
        }
        GAI.sharedInstance().dispatch()
    }
}
