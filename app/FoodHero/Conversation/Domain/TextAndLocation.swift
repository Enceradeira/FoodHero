//
// Created by Jorg on 29/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class TextAndLocation: NSObject, NSCoding {
    let location: String
    let text: String
    public init(text: String, location: String? = nil) {
        self.location = location ?? ""
        self.text = text
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        if let other = object as? TextAndLocation {
            return location == other.location && text == other.text
        } else {
            return false
        }
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(location, forKey: "location");
        aCoder.encodeObject(text, forKey: "text");
    }

    public required init?(coder aDecoder: NSCoder) {
        location = aDecoder.decodeObjectForKey("location") as! String
        text = aDecoder.decodeObjectForKey("text") as! String
    }
}
