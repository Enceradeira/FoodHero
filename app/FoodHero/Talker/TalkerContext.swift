//
// Created by Jorg on 29/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class TalkerContext: NSObject {
    public let randomizer: IRandomizer = TalkerRandomizer()
    public let resources = ScriptResources(randomizer:TalkerRandomizer())

    public init(randomizer: IRandomizer, resources: ScriptResources) {
        self.randomizer = randomizer
        self.resources = resources
    }

}
