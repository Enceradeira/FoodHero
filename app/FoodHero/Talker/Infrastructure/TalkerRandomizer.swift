//
// Created by Jorg on 27/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class TalkerRandomizer: Randomizer {

    public init() {
    }

    public func chooseOne(from choices: [String], forTag tag: RandomizerTags) -> String {
        precondition(choices.count > 0, "choises is empty")

        let randomIndex = (arc4random() % UInt32(choices.count))
        return choices[Int(randomIndex)]
    }
}
