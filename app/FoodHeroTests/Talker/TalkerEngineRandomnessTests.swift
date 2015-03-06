//
// Created by Jorg on 26/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class TalkerEngineRandomnessTests: TalkerEngineTests {

    func test_talk_ShouldVaryItsUtterances() {
        let choices = ["Hello", "What's up"]

        let script = TestScript().say(oneOf: { $0.words(choices) }).finish()

        for i in 0 ... choices.count - 1 {
            randomizerWillChoose(forTag: RandomizerConstants.texts(), index: i)
            assert(dialog: [choices[i]], forExecutedScript: script)
        }
    }

    func test_talk_ShouldSubstituteParametersOfTheUtteranceRandomly() {
        var resources = TestScriptResources().add(parameter: "food", withValues: ["Indian", "Chinese"])

        let script = TestScript(resources).say({ $0.words("Do you like {food} food?") }).finish()

        randomizerWillChoose(forTag: RandomizerConstants.textParameters(), index: 0)
        assert(dialog: ["Do you like Indian food?"], forExecutedScript: script)

        randomizerWillChoose(forTag: RandomizerConstants.textParameters(), index: 1)
        assert(dialog: ["Do you like Chinese food?"], forExecutedScript: script)
    }
}
