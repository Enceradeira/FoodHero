//
// Created by Jorg on 27/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public protocol Randomizer {
    func chooseOne(choices: [String]) -> String
}
