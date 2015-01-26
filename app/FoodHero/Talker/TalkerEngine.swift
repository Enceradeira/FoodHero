//
//  TalkerEngine.swift
//  FoodHero
//
//  Created by Jorg on 24/01/2015.
//  Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class TalkerEngine: NSObject {
    private let _script: Script
    private let _input: RACSequence

    public init(_ script: Script, _ input: RACSequence) {
        self._script = script
        self._input = input
    }

    private func produceNext(utterances: [Utterance], _ input: RACSignal, _ listener: RACSubscriber) {
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

    public func execute() -> RACSignal {
        let signal = RACSignal.createSignal {
            listener in

            let utterances = self._script.utterances
            let input = self._input.signal()

            self.produceNext(utterances, input, listener)

            return nil
        }
        return signal
    }
}