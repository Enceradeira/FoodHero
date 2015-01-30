//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class DelayedUtterance: Utterance {
    private let _continuation: (response:String, script:Script) -> () = {
        r, s in }
    private let _context = TalkerContext()

    init(_ continuation: (response:String, script:Script) -> (), _ context: TalkerContext) {
        _continuation = continuation
        _context = context
    }

    func execute(input: RACSignal) -> RACSignal {
        return RACSignal.createSignal {
            listener in
            input.subscribeNext {
                response in
                listener.sendNext(response)

                let subScript = Script(self._context)
                self._continuation(response: response as String, script: subScript)
                Sequence.execute(subScript, input, listener)

                listener.sendCompleted()
            }
        }

    }
}