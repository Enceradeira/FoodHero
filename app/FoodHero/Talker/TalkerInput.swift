//
// Created by Jorg on 31/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class TalkerInput {
    private let _talkerMode: TalkerMode
    private var _currCallback: (TalkerUtterance) -> () = {
        utterance in }
    private var _currErrorHandler: ((NSError) -> ())? = nil

    init(_ input: RACSignal, _ talkerMode: TalkerMode) {
        _talkerMode = talkerMode

        input.subscribeNext {
            object in
            if let utterance = object! as? TalkerUtterance {
                self.sendNext(utterance)
            } else if let error = object! as? NSError {
                self.sendError(error)
            } else {
                assert(false, "unexpected type \(reflect(object).summary) on input stream")
            }
        }
    }

    private func sendError(error: NSError) {
        let errorHandler = self._currErrorHandler
        if errorHandler != nil {
            _currErrorHandler = nil
            errorHandler!(error)
        }
    }


    private func sendNext(utterance: TalkerUtterance) {
        let callback = _currCallback

        // reset _currCallback before calling it because calling the callback might trigger a new _currCallback being installed!
        _currCallback = {
            utterance in
        }
        // _currErrorHandler = nil

        callback(utterance)
    }

    func getNext(errorHandler: (NSError) -> (), _ callback: (TalkerUtterance) -> ()) {
        _currCallback = callback
        _currErrorHandler = errorHandler

        // someone wants to consume Input therefore we toggle mode to Input
        _talkerMode.Mode = TalkerModes.Inputting
    }

}
