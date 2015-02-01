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
            let text = object! as String
            self.sendNext(text)
        }
    }

    private var _currCallback: (String) -> () = {
        utterance in }


    private func sendNext(utterance: String) {
        _currCallback(utterance)
        _currCallback = {
            utterance in
        }
    }

    func getNext(callback: (String) -> ()) {
        // someone wants to consume Input therefore we toggle mode to Input
        _talkerMode.Mode = TalkerModes.Inputting

        _currCallback = callback
    }
}
