//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class OutputUtterance: Utterance {
    private let _texts: Choices
    private let _customData: AnyObject?
    init(_ texts: Choices, _ customData: AnyObject?) {
        _texts = texts
        _customData = customData;
    }

    func execute(input: TalkerInput, _ output: TalkerOutput, continuation: () -> ()) {
        let text = self._texts.getOne()
        output.sendNext(TalkerUtterance(utterance: text, customData: _customData), andNotifyMode: TalkerModes.Outputting)
        continuation()
    }
}