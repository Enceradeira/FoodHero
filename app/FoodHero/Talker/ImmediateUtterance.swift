//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class ImmediateUtterance: Utterance {
    private let _texts: Choices
    init(_ texts: Choices) {
        self._texts = texts
    }

    func execute(input: RACSignal) -> RACSignal {
        return RACSignal.createSignal({
            l in
            l.sendNext(self._texts.getOne())
            l.sendCompleted()
            return nil
        })
    }

    func concat(utterance: ImmediateUtterance) -> ImmediateUtterance {
        var text1 = self._texts;
        var text2 = utterance._texts;
        return ImmediateUtterance(text1.concat(text2))
    }

}