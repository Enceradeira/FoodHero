//
// Created by Jorg on 21/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class StringDefinition {

    internal class Result {
        internal init(choices: Choices, customData: AnyObject?) {
            self.choises = choices
            self.customData = customData
        }
        internal let choises: Choices
        internal let customData: AnyObject?
    }

    private let _result: RACSubject = RACReplaySubject()
    private let _context: TalkerContext

    internal init(context: TalkerContext) {
        _context = context;
    }

    public func words(texts: [String], withCustomData customData: AnyObject? = nil) -> StringDefinition {
        _result.sendNext(Result(choices: Choices(texts, _context), customData: customData))
        _result.sendCompleted()
        return self;
    }

    public func words(text: String, withCustomData customData: AnyObject? = nil) -> StringDefinition {
        return words([text], withCustomData: customData);
    }

    public var text: RACSignal {
        get {
            return _result;
        }
    }
}
