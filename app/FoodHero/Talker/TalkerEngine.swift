//
//  TalkerEngine.swift
//  FoodHero
//
//  Created by Jorg on 24/01/2015.
//  Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class TalkerEngine: NSObject {
    let script : Script
    public init(_ script: Script) {
        self.script = script
    }

    public func talk() -> RACSignal {
        let signal = RACSignal.createSignal {
            subscriber in

            subscriber.sendNext("Hello")

            subscriber.sendCompleted()
            return nil
        }
        return signal
    }
}