//
// Created by Jorg on 26/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class Choices: NSObject {
    private let _texts: [String] = []
    private var _next: Choices?
    private let _randomizer: Randomizer
    init(_ choices: [String], _ randomizer: Randomizer) {
        precondition(choices.count > 0, "invalid argument choises. Choises can't be empty")
        _texts = choices
        _randomizer = randomizer
    }

    private func collectConcatenation(current: Choices?) -> [Choices] {
        if (current == nil) {
            return []
        } else {
            return [current!] + collectConcatenation(current!._next)
        }
    }

    func concat(_ choices: Choices) -> Choices {
        let choises1 = Choices(_texts,_randomizer)
        let choises2 = Choices(choices._texts,_randomizer)
        choises1._next = choises2
        return choises1
    }

    func getOne() -> String {
        let texts = collectConcatenation(self).map {
            choices in self._randomizer.chooseOne(choices._texts)
        }
        return "\n\n".join(texts)
    }

}
