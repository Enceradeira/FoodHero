//
//  TalkerEngine.swift
//  FoodHero
//
//  Created by Jorg on 24/01/2015.
//  Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class TalkerEngine: NSObject {
    private let _input: RACSignal
    private let _talkerMode = TalkerMode()
    private let _talkerInput: TalkerInput
    private let _talkerOutput: TalkerOutput
    private let _rawOutput = RACReplaySubject()
    private let _naturalOutput = RACReplaySubject()

    public init(input: RACSignal) {
        self._input = input

        _talkerInput = TalkerInput(self._input, _talkerMode)
        _talkerOutput = TalkerOutput(rawOutput: _rawOutput, naturalOutput: _naturalOutput, mode: _talkerMode)
    }

    public func execute(script: Script) -> TalkerStreams {
        script.engine = self

        Sequence.execute(script, _talkerInput, _talkerOutput, {
            self._talkerMode.Mode = TalkerModes.Finishing
            self._talkerOutput.sendCompleted()
        })

        return TalkerStreams(rawOutput: _rawOutput, naturalOutput: _naturalOutput)
    }

    public func interrupt(with subscribt: Script) {
        subscribt.engine = self

        // cut off scripts that are listing on standard input
        _talkerInput.stop()

        // create tmp input on which events are forwarded to listener
        let tmpInput = TalkerInput(_input, _talkerMode)
        Sequence.execute(subscribt, tmpInput, _talkerOutput, {
            tmpInput.stop()

            self._talkerOutput.flush()
            // reactive script that were listing on input
            self._talkerInput.resume()
        })
    }
}