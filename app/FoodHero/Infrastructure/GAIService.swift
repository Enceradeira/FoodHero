//
// Created by Jorg on 10/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class GAIService: NSObject {
    private static var _tracker: GAITracker! = nil

    public class func configure(completion: () -> ()) {
        let isInSimulator = Environment.isRunningInSimulator()

        GAI.sharedInstance().dryRun = isInSimulator
        GAI.sharedInstance().trackUncaughtExceptions = true
        // GAI.sharedInstance().logger.logLevel = GAILogLevel.Verbose
        // GAI.sharedInstance().dispatchInterval = 20
        self._tracker = GAI.sharedInstance().trackerWithTrackingId("UA-25686837-2")

        let version = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
        let shortVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString" as String) as! String

        self._tracker.set(kGAIAppVersion, value: "\(shortVersion).\(version)")
        self._tracker.set("&uid", value: Configuration.userId())

        Configuration.allowDataCollection() {
            allowed in
            // submit data before switching off
            self.dispatch()

            // wait before switching off in order that dispatch can complete
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                GAI.sharedInstance().optOut = !allowed
            }
            completion()
        }
    }

    public class func logScreenViewed(screenName: String) {
        NSLog("GAI:ScreenView: \(screenName)")
        _tracker.set(kGAIScreenName, value: screenName)
        _tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject:AnyObject])
    }

    public class func logEventWithCategory(category: String, action: String, label: String, value: Float) {
        NSLog("GAI:Event: \(category):\(action):\(label):\(value)")
        let event = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build();
        _tracker.send(event as [NSObject:AnyObject])

    }

    public class func logTimingWithCategory(category: String, name: String, label: String, interval: NSTimeInterval) {
        let absInterval = abs(interval * 1000)
        let absIntervalInt: Int = Int(absInterval)
        NSLog("GAI:Timing: \(category):\(name):\(label):\(absInterval)")
        let timing = GAIDictionaryBuilder.createTimingWithCategory(category, interval: absIntervalInt, name: name, label: label).build();
        _tracker.send(timing as [NSObject:AnyObject])
    }

    public class func dispatch() {
        GAI.sharedInstance().dispatch()
    }
}
