//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class ResponseUtterance: Utterance {
    private let _continuation: (response:TalkerUtterance, script:FutureScript) -> (FutureScript) = {
        r, s in return s
    }
    private let _errorHandler: ((NSError, Script) -> Script)?
    private let _context: TalkerContext

    init(_ continuation: (response:TalkerUtterance, script:FutureScript) -> (FutureScript), _ errorHandler: ((NSError, Script) -> Script)?, _ context: TalkerContext) {
        _continuation = continuation
        _context = context
        _errorHandler = errorHandler
    }

    func execute(input: TalkerInput, _ output: TalkerOutput, continuation: () -> ()) {
        input.getNext({
            error in
            if let errorHandler = self._errorHandler? {
                // build & execute error script & continue
                let errorScript = Script(context: self._context)
                errorHandler(error, errorScript)
                Sequence.execute(errorScript, input, output, continuation);
            } else {
                // just continue
                continuation()
            }
        }, {
            utterance in

            output.sendNext(utterance, andNotifyMode: TalkerModes.Inputting)

            let futureScript = FutureScript(context: self._context)
            self._continuation(response: utterance, script: futureScript)
            futureScript.script.subscribeNext {
                Sequence.execute($0 as Script, input, output, continuation);
            }
        })
    }
}