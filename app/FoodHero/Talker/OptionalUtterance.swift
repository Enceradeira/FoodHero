//
// Created by Jorg on 27/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class OptionalUtterance: Utterance {
    private let _utterance: IUtterance
    private let _tag: String
    private let _context: TalkerContext

    init(utterance: IUtterance, tag: String, context: TalkerContext) {
        _utterance = utterance
        _tag = tag
        _context = context
    }

    override func execute(input: TalkerInput, _ output: TalkerOutput, _ continuation: () -> ()) {
        let randomizer = _context.randomizer
        if (randomizer.isTrue(forTag: _tag)) {
            _utterance.execute(input, output, continuation)
        } else {
            continuation()
        }
    }

    override var hasOutput: Bool {
        get {
            return _utterance.hasOutput;
        }
    }
}
