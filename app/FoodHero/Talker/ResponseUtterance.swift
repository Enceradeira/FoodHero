//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class ResponseUtterance: Utterance {
    private let _continuation: (response:TalkerUtterance, script:FutureScript) -> (FutureScript) = {
        r, s in return s
    }
    private let _context: TalkerContext

    init(_ continuation: (response:TalkerUtterance, script:FutureScript) -> (FutureScript), _ context: TalkerContext) {
        _continuation = continuation
        _context = context
    }

    func execute(input: TalkerInput, _ output: TalkerOutput, continuation: () -> ()) {
        // consume future value from input
        input.getNext {
            utterance in

            output.sendNext(utterance, andNotifyMode: TalkerModes.Inputting)

            let futureScript = FutureScript(context: self._context)
            self._continuation(response: utterance, script: futureScript)
            futureScript.script.subscribeNext {
                Sequence.execute($0 as Script, input, output, continuation);
            }
        }
    }
}