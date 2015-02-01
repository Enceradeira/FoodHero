//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class OutputUtterance: Utterance {
    private let _texts: Choices
    init(_ texts: Choices) {
        self._texts = texts
    }

    func execute(input: TalkerInput, _ output: TalkerOutput, continuation: () -> ()) {
        let text = self._texts.getOne()
        output.sendNext(text, andNotifyMode: TalkerModes.Outputting)
        continuation()
    }
}