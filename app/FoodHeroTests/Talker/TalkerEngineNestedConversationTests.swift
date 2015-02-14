//
// Created by Jorg on 26/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

public class TalkerEngineNestedConversationTests: TalkerEngineTests {

    func test_talk_shouldResponseToResponse_WhenFirstResponse() {
        let script = TestScript()
        .say("How are you?")
        .waitResponse(andContinueWith: {
            response, script in
            switch response {
            case "Good": script.say("I'm glad to hear")
            default: script.say("What did you say?")
            }
        })

        assert(dialog: ["How are you?", "Good", "I'm glad to hear"],
                forExecutedScript: script,
                whenInputIs: { output in return "Good" }

        )
    }

    func test_talk_shouldResponseToResponse_WhenAlternativeResponse() {
        let script = TestScript()
        .say("How are you?")
        .waitResponse(andContinueWith: {
            response, script in
            switch response {
            case "Good": script.say("I'm glad to hear")
            default: script.say("What did you say?")
            }
        })

        assert(dialog: ["How are you?", "*##!!", "What did you say?"],
                forExecutedScript: script,
                whenInputIs: { output in return "*##!!" })
    }

    func test_talk_shouldHandleNestedResponses() {
        let script = TestScript()
        .waitResponse(andContinueWith: {
            _, script in
            script
            .say("What?")
            .waitResponse(andContinueWith: {
                _, script in
                script
                .say("Now I get it")
                return
            })
            return
        })
        .say("Good bye then")

        assert(dialog: ["*##!!", "What?", "I mean hello", "Now I get it\n\nGood bye then"],
                forExecutedScript: script,
                whenInputIs: {
                    switch $0 {
                    case "": return "*##!!"
                    case "What?": return "I mean hello"
                    default: return nil
                    }
                }
        )
    }
}
