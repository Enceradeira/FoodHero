//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

protocol IUtterance: class {
    func execute(engine: TalkerEngine, _ input: TalkerInput, _ output: TalkerOutput, _ continuation: () -> ())
    var hasOutput: Bool { get }
}

class Utterance: IUtterance {
    func execute(engine: TalkerEngine, _ input: TalkerInput, _ output: TalkerOutput, _ continuation: () -> ()) {
        executeWith(engine, input: input, output: output, continuation: continuation)
    }

    func executeWith(engine: TalkerEngine, input: TalkerInput, output: TalkerOutput, continuation: () -> ()) {
        assert(false, "executeWith must be overwritten by subclass")
    }

    var hasOutput: Bool {
        get {
            assert(false, "executeWith must be overwritten by subclass")
            return false
        }
    }
}