//
// Created by Jorg on 27/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class Repetition: Utterance {
    private let _scriptFactory: (FutureScript) -> (FutureScript)
    private let _abortTrigger: (() -> Bool)
    private let _context: TalkerContext
    public init(scriptFactory: (FutureScript) -> (FutureScript), abortTrigger: (() -> Bool), context: TalkerContext) {
        _scriptFactory = scriptFactory
        _abortTrigger = abortTrigger
        _context = context
    }

    func execute(_ input: TalkerInput, _ output: TalkerOutput, continuation: () -> ()) {
        let futureScript = _scriptFactory(FutureScript(context: self._context))
        futureScript.script.subscribeNext {
            Sequence.execute($0 as Script, input, output, {
                if !self._abortTrigger() {
                    self.execute(input, output, continuation)
                } else {
                    continuation()
                }
            })
        }
    }
}
