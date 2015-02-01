//
// Created by Jorg on 26/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

public class TalkerEngineJoinsConsecutiveUtterancesTests: TalkerEngineTests {

    func test_talk_shouldJoinConsecutiveUtterancesTogehter() {
        let script = TestScript()
        .say("Good Morning").say("John")
        .waitResponse(byInvoking: {
            self.responseIs("Hello")
        })
        .say("How are you?").say("Did you sleep well?")
        .waitResponse(byInvoking: {
            self.responseIs("I'm fine")
        })
        .say("OK").say("Good bye")

        assert(dialog: [
                "Good Morning\n\nJohn",
                "Hello",
                "How are you?\n\nDid you sleep well?",
                "I'm fine",
                "OK\n\nGood bye"], forExecutedScript: script)
    }

    func test_talk_shouldJoinConsecutiveUtterancesTogehterBeforeWaitingForResponse() {
        let script = TestScript()
        .say("Good Morning").say("How are you?")
        .waitResponse(byInvoking: {
            // no response during this test
        })

        assert(utterance: "Good Morning\n\nHow are you?", exists: true, inExecutedScript: script)
    }
}