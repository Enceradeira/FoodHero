//
// Created by Jorg on 10/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class Configuration: NSObject {
    public class func userId() -> String {
        let key = "userId"
        let defaults = NSUserDefaults.standardUserDefaults()
        if let id = defaults.stringForKey(key) {
            return id
        } else {
            let id = NSUUID().UUIDString
            defaults.setObject(id, forKey: key)
            return id
        }
    }

    public class func allowDataCollection(completion: (Bool) -> ()) {
        let key = "allowDataCollection"
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey(key) != nil {
            return completion(defaults.boolForKey(key))
        } else {
            let alertController = UIAlertController(title: "Allow “Food Hero” to collect anonymous data to improve feature version?",
                    message: "Collected data includes errors and information about how the App performs and is used. No personal information is collected.",
                    preferredStyle: .Alert)

            let gaiCategory = GAICategories.uIUsage()
            let gaiAction = GAIActions.uIUsageAllowDataCollection()

            let dontAllowAction = UIAlertAction(title: "Don't Allow", style: .Default) {
                action in
                GAIService.logEventWithCategory(gaiCategory, action: gaiAction, label: "NO", value: 0)
                defaults.setObject(false, forKey: key)
                completion(false)
            }

            let allowAction = UIAlertAction(title: "Allow", style: .Default) {
                action in
                GAIService.logEventWithCategory(gaiCategory, action: gaiAction, label: "YES", value: 0)
                defaults.setObject(true, forKey: key)
                completion(true)
            }

            alertController.addAction(dontAllowAction)
            alertController.addAction(allowAction)

            let rootController = UIApplication.sharedApplication().keyWindow?.rootViewController
            assert(rootController != nil, "RootController was nil")
            rootController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}