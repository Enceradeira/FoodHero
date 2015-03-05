//
// Created by Jorg on 27/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class TalkerRandomizerFake: NSObject, IRandomizer {
    private var _configuredChoices = [String: Int]()

    public override init() {
        super.init()
    }

    public func chooseOne(from choices: [AnyObject], forTag tag: String) -> AnyObject {
        precondition(choices.count > 0, "choises is empty")

        return choices[_configuredChoices[tag] ?? 0]
    }

    public func willChoose(forTag tag: String, index: Int) {
        _configuredChoices[tag] = index
    }

    public func willChoose(forTag tag: String, value: Bool) {
        _configuredChoices[tag] = value ? 1 : 0
    }

    public func isTrue(forTag tag: String) -> Bool {
        return chooseOne(from: [true, false], forTag: tag) as Bool
    }
}
