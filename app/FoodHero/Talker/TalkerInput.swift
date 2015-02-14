//
// Created by Jorg on 31/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class TalkerInput {
    private let _talkerMode: TalkerMode

    init(_ input: RACSignal, _ talkerMode: TalkerMode) {
        _talkerMode = talkerMode

        input.subscribeNext {
            object in
            let utterance = object! as TalkerUtterance
            self.sendNext(utterance)
        }
    }

    private var _currCallback: (String) -> () = {
        utterance in }


    private func sendNext(utterance: TalkerUtterance) {
        let callback = _currCallback
        
        // reset _currCallback before calling it because calling the callback might trigger a new _currCallback being installed!
        _currCallback = {
            utterance in
        }
        
        callback(utterance.utterance)
    }

    func getNext(callback: (String) -> ()) {
        _currCallback = callback
        
        // someone wants to consume Input therefore we toggle mode to Input
        _talkerMode.Mode = TalkerModes.Inputting
    }
}
