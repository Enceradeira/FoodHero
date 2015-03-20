//
// Created by Jorg on 19/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class UserIntentUnclearError: NSError {
    let _state: String;
    public init(state: String) {
        _state = state
        super.init(domain: "uk.co.jennius", code: 1, userInfo: nil)
    }

    public required init(coder: NSCoder) {
        _state = coder.decodeObjectForKey("_state") as String
        super.init(coder: coder)
    }

    public var state: String {
        get {
            return _state;
        }
    }
}
