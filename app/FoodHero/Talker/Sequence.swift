//
// Created by Jorg on 30/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class Sequence {
    class func execute(script: Script, _ input: RACSignal, _ listener: RACSubscriber) {
        produceNext(script.utterances, input, listener)
    }

    private class func produceNext(utterances: [Utterance], _ input: RACSignal, _ listener: RACSubscriber) {
        if (utterances.isEmpty) {
            listener.sendCompleted()
        } else {
            let next = utterances.first!;
            let nextCompleted = next.execute(input)
            nextCompleted.subscribeNext {
                listener.sendNext($0)
            }
            nextCompleted.subscribeCompleted({
                let nextUtterances = utterances.filter {
                    let thisNext = next
                    let isUnequal = $0 !== thisNext
                    return isUnequal
                }
                self.produceNext(nextUtterances, input, listener)
            })
        }
    }

}