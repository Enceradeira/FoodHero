//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation


public class Script {
    private var _utterances: [Utterance]

    public init() {
        _utterances = []
    }

    var utterances: [Utterance] {
        return _utterances
    }

    public func say(text: String) -> Script {
        var text2 = text
        var lastUtterance = (utterances.last as? ImmediateUtterance);
        if (lastUtterance != nil) {
            _utterances[_utterances.count - 1] = lastUtterance!.concat(ImmediateUtterance(text))
        }
        else{
            _utterances.append(ImmediateUtterance(text))
        }
        return self
    }

    public func waitResponse() -> Script {
        _utterances.append(DelayedUtterance())
        return self;
    }

}
