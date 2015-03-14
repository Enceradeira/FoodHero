//
// Created by Jorg on 26/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

public class TalkerEngineNestedConversationTests: TalkerEngineTests {

    func test_talk_shouldResponseToResponse_WhenFirstResponse() {
        let script = TestScript()
        .say({ $0.words("How are you?") })
        .waitResponse(andContinueWith: {
            response, future in
            return future.define {
                switch response.utterance {
                case "Good": return $0.say({ $0.words("I'm glad to hear") })
                default: return $0.say({ $0.words("What did you say?") })
                }
            }
        }, catch: nil)


        assert(dialog: ["How are you?", "Good", "I'm glad to hear"],
                forExecutedScript: script,
                whenInputIs: { output in return "Good" }

        )
    }

    func test_talk_shouldResponseToResponse_WhenAlternativeResponse() {
        let script = TestScript()
        .say({ $0.words("How are you?") })
        .waitResponse(andContinueWith: {
            response, future in
            return future.define {
                switch response.utterance {
                case "Good": return $0.say({ $0.words("I'm glad to hear") })
                default: return $0.say({ $0.words("What did you say?") })
                }
            }
        }, catch: nil)


        assert(dialog: ["How are you?", "*##!!", "What did you say?"],
                forExecutedScript: script,
                whenInputIs: { output in return "*##!!" })
    }

    func test_talk_shouldHandleNestedResponses() {
        let script = TestScript()
        .waitResponse(andContinueWith: {
            _, future in
            return future.define {
                return $0
                .say({ $0.words("What?") })
                .waitResponse(andContinueWith: {
                    _, continuedFuture in
                    return continuedFuture.define {
                        $0.say({ $0.words("Now I get it") })
                    }
                }, catch: nil)
            }
        }, catch: nil)
        .say({ $0.words("Good bye then") })


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
