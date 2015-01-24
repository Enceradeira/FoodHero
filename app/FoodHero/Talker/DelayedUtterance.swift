//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class DelayedUtterance: Utterance {
    private let signal: RACSignal;
    init(_ signal: RACSignal) {
        self.signal = signal
    }

    func execute(listener: RACSubscriber) {
        signal.subscribeNext({ listener.sendNext($0) })
    }
}