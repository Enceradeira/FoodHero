//
// Created by Jorg on 06/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class FutureScript: NSObject {
    private let _context: TalkerContext
    private let _scriptSignal = RACReplaySubject()
    private var _script: Script?

    public init(context: TalkerContext) {
        _context = context;
    }

    public func define(definition: Script -> Script) -> FutureScript {
        assert(_script == nil, "the FutureScript has been defined twice")

        _script = Script(talkerContext: _context)
        definition(_script!)

        _scriptSignal.sendNext(_script)
        _scriptSignal.sendCompleted()
        return self
    }

    public var hasNoOutput: Bool {
        get {
            return _script == nil || count(_script!.utterances.filter{$0.hasOutput}) == 0
        }
    }

    public func defineEmpty() -> FutureScript {
        define {
            $0
        }
        return self
    }

    public var script: RACSignal {
        get {
            return _scriptSignal;
        }
    }
}
