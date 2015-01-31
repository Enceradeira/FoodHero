//
// Created by Jorg on 31/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class TalkerInput {

    init(_ input: RACSignal) {
        input.subscribeNext {
            object in
            let text = object! as String
            self.sendNext(text)
        }
    }

    private var _currConsumer: (String) -> () = {
        utterance in }


    private func sendNext(utterance: String) {
        _currConsumer(utterance)
        _currConsumer = {
            utterance in
        }
    }

    func consumeOne(consumer: (String) -> ()) {
        _currConsumer = consumer
    }
}
