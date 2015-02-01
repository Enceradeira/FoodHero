//
// Created by Jorg on 31/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

enum TalkerModes {
    case Undetermined
    case Inputting
    case Outputting
    case Finishing
}

protocol TalkerModeChangedDelegate {
    func modeDidChange(newMode: TalkerModes)
}

class TalkerMode {
    private var _talkerModes = TalkerModes.Undetermined
    private var _modeChangedDelegates = [TalkerModeChangedDelegate]()

    private func modeDidChange(newMode: TalkerModes) {
        for delegate in _modeChangedDelegates {
            delegate.modeDidChange(newMode)
        }
    }

    var Mode: TalkerModes {
        get {
            return _talkerModes
        }
        set(value) {
            let isChanging = value != _talkerModes
            _talkerModes = value
            if (isChanging) {
                modeDidChange(value)
            }

        }
    }

    func addModeChangedDelegate(delegate: TalkerModeChangedDelegate) {
        _modeChangedDelegates.append(delegate)
    }
}
