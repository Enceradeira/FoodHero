//
// Created by Jorg on 27/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class TalkerRandomizerFake: IRandomizer {
    private var _configuredChoices = [String:Int]()

    internal init() {
    }

    internal func chooseOne(from choices: [AnyObject], forTag tag:String) -> AnyObject {
        precondition(choices.count > 0, "choises is empty")

        return choices[_configuredChoices[tag] ?? 0]
    }

    internal func willChoose(forTag tag: String, index: Int) {
        _configuredChoices[tag] = index
    }
}
