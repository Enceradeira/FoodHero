//
// Created by Jorg on 10/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class Continuation: Utterance {
    private let _continuation: (FutureScript) -> (FutureScript)
    private let _context: TalkerContext
    public init(continuation: ((FutureScript) -> (FutureScript)), context: TalkerContext) {
        _continuation = continuation
        _context = context
    }

    override func executeWith(engine: TalkerEngine, input: TalkerInput, output: TalkerOutput, continuation: () -> ()) {
        let futureScript = FutureScript(context: self._context, engine: engine)
        self._continuation(futureScript)
        futureScript.script.subscribeNext {
            Sequence.execute($0 as! Script, input, output, continuation);
        }
        output.flush()
    }

    override var hasOutput: Bool {
        get {
            // Produces output
            return true;
        }
    }
}
