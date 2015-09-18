//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class ResponseUtterance: Utterance {
    private let _continuation: (response:TalkerUtterance, script:FutureScript) -> (FutureScript)
    private let _errorHandler: ((NSError, Script) -> Script)?
    private let _context: TalkerContext

    init(_ continuation: (response:TalkerUtterance, script:FutureScript) -> (FutureScript), _ errorHandler: ((NSError, Script) -> Script)?, _ context: TalkerContext) {
        _continuation = continuation
        _context = context
        _errorHandler = errorHandler
    }

    override func executeWith(engine: TalkerEngine, input: TalkerInput, output: TalkerOutput, continuation: () -> ()) {
        input.getNext({
            error in
            if let errorHandler = self._errorHandler {
                // build & execute error script & continue
                let errorScript = Script(talkerContext: self._context)
                errorScript.engine = engine

                errorHandler(error, errorScript)
                Sequence.execute(errorScript, input, output, continuation);
            } else {
                // just continue
                continuation()
            }
        }, {
            utterance in

            output.sendNext(utterance, andNotifyMode: TalkerModes.Inputting)

            let futureScript = FutureScript(context: self._context, engine: engine)
            self._continuation(response: utterance, script: futureScript)
            if futureScript.hasNoOutput {
                // no output, therefore input is flushed immediatly. This would normally be triggered by
                // a futureScript that produces output which is not the case here.
                output.flush()
            }

            // execute the futureScript
            futureScript.script.subscribeNext {
                Sequence.execute($0 as! Script, input, output, continuation);
            }
        })
    }

    override var hasOutput: Bool {
        get {
            // Only reads input
            return false;
        }
    }
}