//
// Created by Jorg on 18/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class SearchErrorControlInput: NSObject, NSCoding {
    let error: NSError

    public init(error: NSError) {
        self.error = error
    }

    public required init(coder: NSCoder) {
        error = coder.decodeObjectForKey("error") as! NSError
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(error, forKey: "error");
    }

    public override func isEqual(other: AnyObject?) -> Bool {
        if let other = other as? SearchErrorControlInput {
            if error.code != other.error.code {
                return false;
            }
            if error.domain != other.error.domain {
                return false;
            }
            return true;
        }
        return false;
    }
}
