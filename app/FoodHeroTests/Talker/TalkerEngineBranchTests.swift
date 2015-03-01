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
                    return $0.say({
                        $0.words("Hello")
                    }).finish()
                }, {
                    return $0.say({
                        $0.words("Hi")
                    }).finish()
                }
        ], withTag: "Greeting")
        .finish()

        randomizerWillChoose(forTag: "Greeting", index: 0)
        assert(dialog: ["Hello"], forExecutedScript: script)

        randomizerWillChoose(forTag: "Greeting", index: 1)
        assert(dialog: ["Hi"], forExecutedScript: script)
    }

    func test_talk_shouldContinueWithNextUtteranceAfterBranch() {
        let script = TestScript()
        .chooseOne(from: [
                {
                    return $0.say({ $0.words("Hello") }).finish()
                }
        ], withTag: "Greeting")
        .say({ $0.words("John") })
        .finish()

        randomizerWillChoose(forTag: "Greeting", index: 0)
        assert(dialog: ["Hello\n\nJohn"], forExecutedScript: script)
    }

    func test_talk_shouldSkipBranches_WhenNoBranchesSpecified() {
        let script = TestScript()
        .chooseOne(from: [], withTag: "Greeting")
        .say({ $0.words("Bye") }).finish()
        .finish()

        assert(dialog: ["Bye"], forExecutedScript: script)
    }

    func test_talk_shouldContinueBranchOnlyWhenScriptingFinished() {
        var subScript: Script? = nil
        var utterances: [AnyObject] = []

        let script = TestScript()
        .chooseOne(from: [
                {
                    $0.say({ $0.words("Hello") })
                    subScript = $0
                    return subScript!
                }
        ], withTag: "Greeting")
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
