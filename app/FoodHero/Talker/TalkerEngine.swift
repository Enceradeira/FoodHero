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

    public init(_ script: Script) {
        self._script = script
    }

    public func execute() -> RACSignal {
        let signal = RACSignal.createSignal {
            listener in

            for utterance in self._script.utterances{
                utterance.execute(listener)
            }

            listener.sendCompleted()
            return nil
        }
        return signal
    }
}