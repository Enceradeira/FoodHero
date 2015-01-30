//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class DelayedUtterance: Utterance {
    func execute(input: RACSignal) -> RACSignal {
        return RACSignal.createSignal {
            listener in
            input.subscribeNext {
                listener.sendNext($0)
                listener.sendCompleted()
            }
        }

    }
}