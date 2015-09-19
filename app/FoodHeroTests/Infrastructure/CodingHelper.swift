//
// Created by Jorg on 11/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class CodingHelper: NSObject {
    public class func encodeAndDecode<T:AnyObject>(conversation: T) -> T {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(conversation, forKey: "Test")
        archiver.finishEncoding()

        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        return unarchiver.decodeObjectForKey("Test") as! T
    }

    public class func encodeAndDecodeUntyped(conversation: AnyObject) -> AnyObject {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(conversation, forKey: "Test")
        archiver.finishEncoding()

        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        return unarchiver.decodeObjectForKey("Test")!
    }
}
