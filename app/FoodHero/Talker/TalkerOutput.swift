//
// Created by Jorg on 31/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class TalkerOutput: TalkerModeChangedDelegate {
    private let _talkerMode: TalkerMode
    private let _output: RACSubscriber
    private var _buffer = [String]()

    init(_ output: RACSubscriber, _ talkerMode: TalkerMode) {
        _output = output
        _talkerMode = talkerMode
        _talkerMode.addModeChangedDelegate(self)
    }

    func modeDidChange(newMode: TalkerModes) {
        if (_buffer.count > 0) {
            let text = "\n\n".join(_buffer)
            _buffer.removeAll()
            _output.sendNext(text)
        }
    }

    func sendNext(text: String, andNotifyMode reason: TalkerModes) {
        // switches modes which controls the buffering of outputs
        _talkerMode.Mode = reason

        _buffer.append(text)
    }

    func sendCompleted() {
        _output.sendCompleted()
    }
}
