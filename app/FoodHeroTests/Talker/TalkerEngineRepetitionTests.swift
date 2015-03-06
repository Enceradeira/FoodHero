//
// Created by Jorg on 27/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class TalkerEngineRepetitionTests: TalkerEngineTests {
    func test_talk_shouldRepeatUtternaceUntilAborted() {
        var nr: Int = 0

        let script = TestScript()
        .repeat({
            return $0.define {
                nr++
                $0.say {
                    $0.words("Hello \(nr)")
                }
                return $0
            }
        }, until: {
            nr >= 2
        })


        assert(dialog: ["Hello 1\n\nHello 2"], forExecutedScript: script)
    }

    func test_talk_shouldRepeatUtternaceThenAbortAndContinue() {
        let script = TestScript()
        .repeat({
            $0.define {
                $0.say {
                    $0.words("Hello")
                }
            }
        }, until: { true })
        .say({ $0.words("John") })


        assert(dialog: ["Hello\n\nJohn"], forExecutedScript: script)
    }
}
