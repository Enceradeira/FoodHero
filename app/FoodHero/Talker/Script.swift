//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation


public class Script {
    private var _utterances: [Utterance]
    private let _randomizer: Randomizer

    public init(_ randomizer:Randomizer) {
        _utterances = []
        _randomizer = randomizer
    }

    var utterances: [Utterance] {
        return _utterances
    }

    public func say(text:String)->Script{
        return say(oneOf:[text])
    }

    public func say(oneOf texts: [String]) -> Script {
        var lastUtterance = (utterances.last as? ImmediateUtterance);
        if (lastUtterance != nil) {
            _utterances[_utterances.count - 1] = lastUtterance!.concat(ImmediateUtterance(Choices(texts,_randomizer)))
        }
        else{
            _utterances.append(ImmediateUtterance(Choices(texts,_randomizer)))
        }
        return self
    }

    public func waitResponse() -> Script {
        _utterances.append(DelayedUtterance())
        return self;
    }

}
