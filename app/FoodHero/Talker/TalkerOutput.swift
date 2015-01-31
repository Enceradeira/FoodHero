//
// Created by Jorg on 31/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class TalkerOutput {

    let _output: RACSubscriber
    init(_ output: RACSubscriber) {
        _output = output
    }

    func sendNext(text: String) {
        _output.sendNext(text)
    }

    func sendCompleted() {
        _output.sendCompleted()
    }
}
