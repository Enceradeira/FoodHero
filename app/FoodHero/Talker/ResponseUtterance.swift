//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class ResponseUtterance: Utterance {
    private let _continuation: (response:String, script:Script) -> () = {
        r, s in }
    private let _context: TalkerContext

    init(_ continuation: (response:String, script:Script) -> (), _ context: TalkerContext) {
        _continuation = continuation
        _context = context
    }

    func execute(input: TalkerInput, _ output: TalkerOutput, continuation: () -> ()) {
        // consume future value from input
        input.getNext {
            utterance in

            output.sendNext(utterance, andNotifyMode: TalkerModes.Inputting)

            let subScript = Script(context: self._context)
            self._continuation(response: utterance.utterance, script: subScript)
            Sequence.execute(subScript, input, output, continuation);
        }
    }
}