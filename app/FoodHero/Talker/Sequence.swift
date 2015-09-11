//
// Created by Jorg on 30/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class Sequence {
    class func execute(script: Script, _ input: TalkerInput, _ output: TalkerOutput, _ continuation: () -> ()) {
        return produceSequence(script.utterances, input, output, continuation)

    }

    private class func produceSequence(utterances: [IUtterance], _ input: TalkerInput, _ output: TalkerOutput, _ continuation: () -> ()) {
        self.produceNext(utterances, input, output, continuation)
    }

    private class func produceNext(utterances: [IUtterance], _ input: TalkerInput, _ output: TalkerOutput, _ continuation: () -> ()) {
        if (utterances.isEmpty) {
            continuation()
        } else {
            let next = utterances.first!;
            next.execute(input, output, {
                let nextUtterances = utterances.filter {
                    let thisNext = next
                    let isUnequal = $0 !== thisNext
                    return isUnequal
                }
                self.produceNext(nextUtterances, input, output, continuation)
            })
        }
    }
}