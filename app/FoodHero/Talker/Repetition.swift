//
// Created by Jorg on 27/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class Repetition: Utterance {
    private let _scriptFactory: (Script) -> (Script)
    private let _abortTrigger: (() -> Bool)
    private let _context: TalkerContext
    public init(scriptFactory: (Script) -> (Script), abortTrigger: (() -> Bool), context: TalkerContext) {
        _scriptFactory = scriptFactory
        _abortTrigger = abortTrigger
        _context = context
    }

    func execute(_ input: TalkerInput, _ output: TalkerOutput, continuation: () -> ()) {
        let subScript = _scriptFactory(Script(context: self._context))
        Sequence.execute(subScript, input, output, {
            if !self._abortTrigger() {
                self.execute(input, output, continuation)
            } else {
                continuation()
            }
        })
    }
}
