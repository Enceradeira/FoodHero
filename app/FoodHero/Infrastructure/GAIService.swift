//
// Created by Jorg on 10/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class GAIService: NSObject {
    private static var _tracker:GAITracker! = nil

    public class func configure()
    {
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().logger.logLevel = GAILogLevel.Verbose
        GAI.sharedInstance().dispatchInterval = 20
        _tracker = GAI.sharedInstance().trackerWithTrackingId("UA-25686837-2")

        let version = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
        let shortVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString" as String) as! String

        _tracker.set(kGAIAppVersion, value:"\(shortVersion).\(version)")
        _tracker.set("&uid", value:UserId.id())
    }

    public class func logScreenViewed(screenName:String){
        _tracker.set(kGAIScreenName, value: screenName)
        _tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }

    public class func logEvent(category: String, action:String, label:String, value:Float){

        let event = GAIDictionaryBuilder.createEventWithCategory(category, action:action, label:label, value:value).build();
        _tracker.send(event as [NSObject : AnyObject])
    }
}
