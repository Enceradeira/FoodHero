//
// Created by Jorg on 18/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class FoodHeroParameters: ConversationParameters {
    public let state: String?
    public let expectedUserUtterances: ExpectedUserUtterances?

    public init(semanticId: String, state: String?, expectedUserUtterances: ExpectedUserUtterances?) {
        self.state = state
        self.expectedUserUtterances = expectedUserUtterances
        super.init(semanticId: semanticId)
    }

    public override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(expectedUserUtterances, forKey: "expectedUserUtterances");
        aCoder.encodeObject(state, forKey: "state");
    }

    public required init(coder aDecoder: NSCoder) {
        state = aDecoder.decodeObjectForKey("state") as! String?
        expectedUserUtterances = aDecoder.decodeObjectForKey("expectedUserUtterances") as! ExpectedUserUtterances?
        super.init(coder: aDecoder)
    }

    public override func isEqual(other: AnyObject?) -> Bool {
        if let other = other as? FoodHeroParameters {
            if state != other.state {
                return false;
            }
            if expectedUserUtterances != other.expectedUserUtterances {
                return false;
            }
            return super.isEqual(other);
        }
        return false;
    }
}


