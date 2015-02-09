//
// Created by Jorg on 27/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class TalkerRandomizer: NSObject, IRandomizer {
    public func chooseOne(from choices: [String], forTag tag: String) -> String {
        precondition(choices.count > 0, "choises is empty")

        let randomIndex = (arc4random() % UInt32(choices.count))
        return choices[Int(randomIndex)]
    }
}
