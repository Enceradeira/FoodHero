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


    public func execute() -> RACSignal {
        return RACSignal.createSignal {
            subscriber in

            let talkerInput = TalkerInput(self._input)
            let talkerOuput  = TalkerOutput(subscriber)
            Sequence.execute(self._script, talkerInput, talkerOuput, { subscriber.sendCompleted() })
            return nil
        }
    }
}