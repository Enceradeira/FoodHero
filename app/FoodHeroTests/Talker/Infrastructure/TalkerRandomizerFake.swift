//
// Created by Jorg on 27/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class TalkerRandomizerFake: Randomizer {
    private var _configuredChoices = [RandomizerTags:Int]()

    internal init() {
    }

    internal func chooseOne(from choices: [String], forTag tag:RandomizerTags) -> String {
        precondition(choices.count > 0, "choises is empty")

        return choices[_configuredChoices[tag] ?? 0]
    }

    internal func willChoose(forTag tag: RandomizerTags, #index: Int) {
        _configuredChoices[tag] = index
    }
}
