//
// Created by Jorg on 27/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class TalkerRandomizerFake: Randomizer {
    private var choiceIndex: Int?

    public init(){}

    public func chooseOne(choices: [String]) -> String {
        precondition(choices.count > 0, "choises is empty")
        return choices[choiceIndex ?? 0]
    }

    public func injectChoice(#index: Int?) {
        choiceIndex = index
    }
}
