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


    public func execute() -> RACSignal {
        let signal = RACSignal.createSignal {
            listener in

            let input = self._input.signal()

            Sequence.execute(self._script, input, listener)

            return nil
        }
        return signal
    }
}