//
// Created by Jorg on 29/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class TalkerContext: NSObject {
    public var randomizer: Randomizer = TalkerRandomizer()
    public var resources = ScriptResources(TalkerRandomizer())
}
