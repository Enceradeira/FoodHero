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
    private let _input: RACSignal

    public init(_ script: Script, _ input: RACSignal) {
        self._script = script
        self._input = input
    }

    private func produceNext(utterances: [Utterance], _ listener: RACSubscriber) {
        if (utterances.isEmpty) {
            listener.sendCompleted()
        } else {
            let next = utterances.first!;
            let nextCompleted = next.execute(_input)
            nextCompleted.subscribeNext {
                listener.sendNext($0)
            }
            nextCompleted.subscribeCompleted({
                let nextUtterances = utterances.filter {
                    $0 !== next
                }
                self.produceNext(nextUtterances, listener)
            })
        }
    }

    public func execute() -> RACSignal {

        let signal = RACSignal.createSignal {
            listener in

            let utterances = self._script.utterances
            self.produceNext(utterances, listener)

            return nil
        }
        return signal
    }
}