//
// Created by Jorg on 27/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

@objc
public protocol IRandomizer {
    func chooseOne(from choices: [String], forTag tag: String) -> String
}