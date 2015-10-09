//
// Created by Jorg on 26/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

public class TalkerEngineJoinsConsecutiveUtterancesTests: TalkerEngineTests {

    func test_talk_shouldJoinConsecutiveUtterancesTogehter_WhenNaturalOutput() {
        let script = TestScript()
        .say(oneOf: { $0.words("Good Morning") }).say(oneOf: { $0.words("John") })
        .waitResponse(`catch`: nil)
        .say(oneOf: { $0.words("How are you?") }).say(oneOf: { $0.words("Did you sleep well?") })
        .waitResponse(`catch`: nil)
        .say(oneOf: { $0.words("OK") }).say(oneOf: { $0.words("Good bye") })


        assert(dialog: [
                "Good Morning\n\nJohn",
                "Hello",
                "How are you?\n\nDid you sleep well?",
                "Yes I did",
                "OK\n\nGood bye"],
                forExecutedScript: script,
                whenInputIs: {
                    utterance, engine in
                    switch utterance {
                    case "Good Morning\n\nJohn":
                        return "Hello"
                    case "How are you?\n\nDid you sleep well?":
                        return "Yes I did"
                    default:
                        return nil;
                    }
                },
                withNaturalOutput: true)
    }

    func test_talk_shouldJoinConsecutiveUtterancesTogehterBeforeWaitingForResponse_WhenNaturalOutput() {
        let script = TestScript()
        .say(oneOf: { $0.words("Good Morning") }).say(oneOf: { $0.words("How are you?") })
        .waitResponse(`catch`: nil)


        assert(utterance: "Good Morning\n\nHow are you?", exists: true, inExecutedScript: script)
    }

    func test_talk_shouldNotJoinConsecutiveUtterancesTogehter_WhenRawOutput() {
        let script = TestScript()
        .say(oneOf: { $0.words("Good Morning") }).say(oneOf: { $0.words("How are you?") })
        .waitResponse(`catch`: nil)


        assert(utterance: "Good Morning", exists: true, inExecutedScript: script, atPosition: 0, withNaturalOutput: false)
        assert(utterance: "How are you?", exists: true, inExecutedScript: script, atPosition: 1, withNaturalOutput: false)
    }

}