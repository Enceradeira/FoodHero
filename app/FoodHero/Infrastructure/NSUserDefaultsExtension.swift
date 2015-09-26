//
// Created by Jorg on 26/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

extension NSUserDefaults {
    public class func removeAllPersistedDefaults() {
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
    }
}
