//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class ImmediateUtterance: Utterance {
    private let text: String
    init(_ text: String) {
        self.text = text
    }

    func execute(_ input: RACSignal) -> RACSignal {
        return RACSignal.createSignal({
            l in
            l.sendNext(self.text)
            l.sendCompleted()
            return nil
        })
    }

    func concat(utterance: ImmediateUtterance) -> ImmediateUtterance {
        var text1 = self.text;
        var text2 = utterance.text;
        return ImmediateUtterance("\(text1)\n\n\(text2)")
    }

}