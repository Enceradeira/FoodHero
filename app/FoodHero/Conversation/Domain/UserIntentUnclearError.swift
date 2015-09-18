//
// Created by Jorg on 19/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class UserIntentUnclearError: NSError {
    let _state: String;
    let _expectedUserUtterances: ExpectedUserUtterances
    public init(state: String, expectedUserUtterances: ExpectedUserUtterances) {
        _state = state
        _expectedUserUtterances = expectedUserUtterances;
        super.init(domain: "uk.co.jennius", code: 1, userInfo: nil)
    }

    public required init(coder: NSCoder) {
        _state = coder.decodeObjectForKey("_state") as! String
        _expectedUserUtterances = coder.decodeObjectForKey("_expectedUserUtterances") as! ExpectedUserUtterances
        super.init(coder: coder)
    }

    public override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_expectedUserUtterances, forKey: "_expectedUserUtterances");
        aCoder.encodeObject(_state, forKey: "_state");
    }

    public override func isEqual(other: AnyObject?) -> Bool {
        if let other = other as? UserIntentUnclearError {
            if _state != other._state {
                return false;
            }
            if _expectedUserUtterances != other._expectedUserUtterances {
                return false;
            }
        }
        return super.isEqual(other);
    }

    public var state: String {
        get {
            return _state;
        }
    }

    public var expectedUserUtterances: ExpectedUserUtterances {
        get {
            return _expectedUserUtterances;
        }
    }
}
