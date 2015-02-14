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
        .waitResponse()
        .say("How are you?").say("Did you sleep well?")
        .waitResponse()
        .say("OK").say("Good bye")

        assert(dialog: [
                "Good Morning\n\nJohn",
                "Hello",
                "How are you?\n\nDid you sleep well?",
                "Yes I did",
                "OK\n\nGood bye"],
                forExecutedScript: script,
                whenInputIs: {
                    switch $0 {
                    case "Good Morning\n\nJohn":
                        return "Hello"
                    case "How are you?\n\nDid you sleep well?":
                        return "Yes I did"
                    default:
                        return nil;
                    }
                })
    }

    func test_talk_shouldJoinConsecutiveUtterancesTogehterBeforeWaitingForResponse() {
        let script = TestScript()
        .say("Good Morning").say("How are you?")
        .waitResponse()

        assert(utterance: "Good Morning\n\nHow are you?", exists: true, inExecutedScript: script)
    }
}