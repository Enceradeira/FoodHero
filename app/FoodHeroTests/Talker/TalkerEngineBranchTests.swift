//
// Created by Jorg on 26/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class TalkerEngineBranchTests: TalkerEngineTests {

    func test_talk_shouldChooseOneConversationBranch() {
        let script = TestScript()
        .chooseOne(from: [
                {
                    return $0.define {
                        $0.say(oneOf: {
                            $0.words("Hello")
                        })
                    }
                }, {
                    return $0.define {
                        $0.say(oneOf: {
                            $0.words("Hi")
                        })
                    }
                }
        ], withTag: "Greeting")


        randomizerWillChoose(forTag: "Greeting", index: 0)
        assert(dialog: ["Hello"], forExecutedScript: script)

        randomizerWillChoose(forTag: "Greeting", index: 1)
        assert(dialog: ["Hi"], forExecutedScript: script)
    }

    func test_talk_shouldContinueWithNextUtteranceAfterBranch() {
        let script = TestScript()
        .chooseOne(from: [
                {
                    return $0.define {
                        $0.say(oneOf: { $0.words("Hello") })
                    }
                }
        ], withTag: "Greeting")
        .say(oneOf: { $0.words("John") })


        randomizerWillChoose(forTag: "Greeting", index: 0)
        assert(dialog: ["Hello\n\nJohn"], forExecutedScript: script)
    }

    func test_talk_shouldSkipBranches_WhenNoBranchesSpecified() {
        let script = TestScript()
        .chooseOne(from: [], withTag: "Greeting")
        .say(oneOf: { $0.words("Bye") })


        assert(dialog: ["Bye"], forExecutedScript: script)
    }
}
