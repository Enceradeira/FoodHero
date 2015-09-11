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
    private let _talkerMode = TalkerMode()
    private let _talkerInput: TalkerInput
    private let _talkerOutput: TalkerOutput
    private let _rawOutput = RACReplaySubject()
    private let _naturalOutput = RACReplaySubject()

    public init(script: Script, input: RACSignal) {
        self._script = script
        self._input = input

        _talkerInput = TalkerInput(self._input, _talkerMode)
        _talkerOutput = TalkerOutput(rawOutput: _rawOutput, naturalOutput: _naturalOutput, mode: _talkerMode)
    }

    public func execute() -> TalkerStreams {
        Sequence.execute(self._script, _talkerInput, _talkerOutput, {
            self._talkerMode.Mode = TalkerModes.Finishing
            self._talkerOutput.sendCompleted()
        })

        return TalkerStreams(rawOutput: _rawOutput, naturalOutput: _naturalOutput)
    }

    public func interrupt(with script: (Script) -> (Script)) {
        let subscribt = script(Script(talkerContext: _script.context))

        // cut off scripts that are listing on standard input
        _talkerInput.stop()

        // create tmp input on which events are forwarded to listener
        let tmpInput = TalkerInput(_input, _talkerMode)
        Sequence.execute(subscribt, tmpInput, _talkerOutput, {
            self._talkerOutput.flush()
            // reactive script that were listing on input
            self._talkerInput.resume()
        })
    }
}