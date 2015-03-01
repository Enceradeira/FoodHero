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
            nr++
            $0.say {
                $0.words("Hello \(nr)")
            }
            return $0.finish()
        }, until: {
            nr >= 2
        })
        .finish()

        assert(dialog: ["Hello 1\n\nHello 2"], forExecutedScript: script)
    }

    func test_talk_shouldRepeatUtternaceThenAbortAndContinue() {
        var nr = 1

        let script = TestScript()
        .repeat({
            $0.say {
                $0.words("Hello")
            }.finish()
        }, until: { true })
        .say({ $0.words("John") })
        .finish()

        assert(dialog: ["Hello\n\nJohn"], forExecutedScript: script)
    }

    func test_talk_shouldStartRepetitionOnlyWhenScriptingFinished() {
        var subScript: Script? = nil
        var utterances: [AnyObject] = []

        let script = TestScript()
        .repeat({
            $0.say {
                $0.words("Hello")
            }
            subScript = $0
            return subScript!
        }, until: { true })
        .finish()

        let dialog = executeScript(script, withNaturalOutput: false)
        dialog.subscribeNext {
            (object: AnyObject?) in
            utterances.append(object!)
        }

        XCTAssertEqual(utterances.count, 0, "No utterances should be yielded befor script finish is called")

        subScript!.finish()

        XCTAssertEqual(utterances.count, 1, "No utterances have been yielded")
    }

}
