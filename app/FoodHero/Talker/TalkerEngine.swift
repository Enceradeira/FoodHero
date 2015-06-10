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

    public init(script: Script, input: RACSignal) {
        self._script = script
        self._input = input
    }

    public func execute() -> TalkerStreams {
        let rawOutput = RACReplaySubject()
        let naturalOutput = RACReplaySubject()

        let talkerMode = TalkerMode()
        let talkerInput = TalkerInput(self._input, talkerMode)
        let talkerOuput = TalkerOutput(rawOutput: rawOutput, naturalOutput: naturalOutput, mode: talkerMode)

        Sequence.execute(self._script, talkerInput, talkerOuput, {
            talkerMode.Mode = TalkerModes.Finishing
            talkerOuput.sendCompleted()
        })

        return TalkerStreams(rawOutput: rawOutput, naturalOutput: naturalOutput)
    }
}