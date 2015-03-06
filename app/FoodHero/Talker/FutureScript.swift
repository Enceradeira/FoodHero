//
// Created by Jorg on 06/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class FutureScript: NSObject {
    private let _context: TalkerContext
    private let _scriptSignal = RACReplaySubject()
    private var _isDefined = false

    public init(context: TalkerContext) {
        _context = context;
    }

    public func define(definition: Script -> Script) -> FutureScript {
        assert(!_isDefined, "the FutureScript has been defined twice")
        _isDefined = true

        let script = Script(context: _context)
        definition(script)

        _scriptSignal.sendNext(script)
        _scriptSignal.sendCompleted()
        return self
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
