//
// Created by Jorg on 10/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class UserId: NSObject {
    private static let _id =  NSUUID().UUIDString
    public class func id() -> String{
        return _id
    }
}
