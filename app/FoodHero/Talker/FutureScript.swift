//
// Created by Jorg on 06/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class FutureScript: NSObject {
    private let _context: TalkerContext
    private let _scriptSignal = RACReplaySubject()
    private let _engine: TalkerEngine
    private var _script: Script?

    public init(context: TalkerContext, engine: TalkerEngine) {
        _context = context;
        _engine = engine
    }

    private func sendScript() {
        _scriptSignal.sendNext(_script)
        _scriptSignal.sendCompleted()
    }

    public func define(definition: Script -> Script) -> FutureScript {
        assert(_script == nil, "the FutureScript has been defined twice")

        _script = Script(talkerContext: _context)
        _script!.engine = _engine

        definition(_script!)
        sendScript()

        return self
    }

    public func defineWithScript(script: Script) -> FutureScript {
        _script = script
        sendScript()
        return self;
    }

    public var hasNoOutput: Bool {
        get {
            return _script == nil || _script!.utterances.filter {
                $0.hasOutput
            }.count == 0
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
