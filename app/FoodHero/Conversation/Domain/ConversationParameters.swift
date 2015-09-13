//
// Created by Jorg on 22/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class ConversationParameters: NSObject {
    public let semanticIdInclParameters: String

    public init(semanticId: String) {
        self.semanticIdInclParameters = semanticId
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(semanticIdInclParameters, forKey: "semanticIdInclParameters");
    }

    public required init(coder aDecoder: NSCoder) {
        semanticIdInclParameters = aDecoder.decodeObjectForKey("semanticIdInclParameters") as! String
    }

    public override func isEqual(other: AnyObject?) -> Bool {
        if let other = other as? ConversationParameters {
            if semanticIdInclParameters != other.semanticIdInclParameters {
                return false;
            }
            return true;
        }
        return false;
    }

    public func hasSemanticId(semanticId: String) -> Bool {
        return self.semanticIdInclParameters.rangeOfString(semanticId) != nil
    }
}


