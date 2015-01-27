//
// Created by Jorg on 26/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class TalkerEngineRandomnessTests: TalkerEngineTests {


    func test_talk_ShouldVaryItsUtterances() {
        let choices = ["Hello", "What's up"]

        let script = TestScript().say(oneOf: choices)

        for i in 0 ... choices.count - 1 {
            randomizerChooses(index: i)
            assert(dialog: [choices[i]], forExecutedScript: script)
        }
    }
}
