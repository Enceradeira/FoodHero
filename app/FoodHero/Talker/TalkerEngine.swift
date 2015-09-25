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
    private var _talkerInputs: [TalkerInput] = []
    private let _talkerOutput: TalkerOutput
    private let _rawOutput = RACReplaySubject()
    private let _naturalOutput = RACReplaySubject()
    public let output: TalkerStreams

    public init(input: RACSignal) {
        self._input = input

        _talkerOutput = TalkerOutput(rawOutput: _rawOutput, naturalOutput: _naturalOutput, mode: _talkerMode)
        output = TalkerStreams(rawOutput: _rawOutput, naturalOutput: _naturalOutput)
    }

    public func execute(script: Script) {
        script.engine = self

        let talkerInput = TalkerInput(self._input, _talkerMode)
        _talkerInputs.append(talkerInput)

        Sequence.execute(script, talkerInput, _talkerOutput, {
            self._talkerMode.Mode = TalkerModes.Finishing
            self._talkerOutput.sendCompleted()
        })
    }

    public func interrupt(with subscribt: Script) {
        subscribt.engine = self

        // cut off scripts that are listening on standard input
        for input in _talkerInputs {
            input.stop()
        }

        // create tmp input on which events are forwarded to listener
        let tmpInput = TalkerInput(_input, _talkerMode)
        _talkerInputs.append(tmpInput)

        Sequence.execute(subscribt, tmpInput, _talkerOutput, {
            tmpInput.stop()
            self._talkerInputs = self._talkerInputs.filter {
                $0 !== tmpInput
            }

            self._talkerOutput.flush()
            // reactive last script that was listing on input
            if self._talkerInputs.count > 0 {
                self._talkerInputs[self._talkerInputs.count - 1].resume()
            }
        })
    }
}