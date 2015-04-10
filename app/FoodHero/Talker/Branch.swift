//
// Created by Jorg on 26/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class Branch: Utterance {
    private let _tag: String;
    private let _branches: [((FutureScript) -> (FutureScript))]
    private let _context: TalkerContext

    init(tag: String, branches: [((FutureScript) -> (FutureScript))], context: TalkerContext) {
        _tag = tag
        _branches = branches
        _context = context
    }

    func execute(input: TalkerInput, _ output: TalkerOutput, _ continuation: () -> ()) {
        let futureScript = FutureScript(context: self._context)

        if _branches.count > 0 {
            let surrogate = Array(0 ..< _branches.count) // surrogate because chooseOne doesn't accept [((Script) -> (Script))]
            let index = _context.randomizer.chooseOne(from: surrogate, forTag: _tag) as! Int
            let chosenScriptFactory = _branches[index]
            chosenScriptFactory(futureScript)

            futureScript.script.subscribeNext {
                Sequence.execute($0 as! Script, input, output, continuation);
            }
        } else {
            continuation()
        }


    }

}
