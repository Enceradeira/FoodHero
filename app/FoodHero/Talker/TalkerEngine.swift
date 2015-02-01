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

    public init(_ script: Script, input input: RACSignal) {
        self._script = script
        self._input = input
    }

    public override init() {
        self._script = Script(TalkerContext())
        self._input = RACSignal.empty()
        super.init()
    }


    public func execute() -> RACSignal {
        return RACSignal.createSignal {
            subscriber in

            let talkerMode = TalkerMode()
            let talkerInput = TalkerInput(self._input, talkerMode)
            let talkerOuput = TalkerOutput(subscriber, talkerMode)
            Sequence.execute(self._script, talkerInput, talkerOuput, {
                talkerMode.Mode = TalkerModes.Finishing
                subscriber.sendCompleted()
            })
            return nil
        }
    }
}