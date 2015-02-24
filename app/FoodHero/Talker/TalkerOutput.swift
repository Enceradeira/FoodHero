//
// Created by Jorg on 31/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class TalkerOutput: TalkerModeChangedDelegate {
    private let _talkerMode: TalkerMode
    private let _naturalOutput: RACSubscriber
    private let _rawOutput: RACSubscriber
    private var _naturalBuffer = [TalkerUtterance]()

    init(rawOutput: RACSubscriber, naturalOutput: RACSubscriber, mode: TalkerMode) {
        _naturalOutput = naturalOutput
        _rawOutput = rawOutput
        _talkerMode = mode
        _talkerMode.addModeChangedDelegate(self)
    }

    func modeDidChange(newMode: TalkerModes) {
        if (_naturalBuffer.count > 0) {
            // let text = "\n\n".join(_buffer)
            let utterance = _naturalBuffer.reduce(TalkerUtterance(), { $0.concat($1) })

            _naturalBuffer.removeAll()
            _naturalOutput.sendNext(utterance)
        }
    }

    func sendNext(utterance: TalkerUtterance, andNotifyMode reason: TalkerModes) {
        // switches modes which controls the buffering of outputs
        _talkerMode.Mode = reason

        _rawOutput.sendNext(utterance)
        _naturalBuffer.append(utterance)
    }

    func sendCompleted() {
        _naturalOutput.sendCompleted()
        _rawOutput.sendCompleted()
    }
}
