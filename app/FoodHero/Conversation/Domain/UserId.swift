//
// Created by Jorg on 10/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class UserId: NSObject {
    public class func id() -> String{
        let key = "userId"
        let defaults = NSUserDefaults.standardUserDefaults()
        if let id = defaults.stringForKey(key)
        {
            return id
        }
        else{
            let id = NSUUID().UUIDString
            defaults.setObject(id, forKey: key)
            return id
        }
    }
}
