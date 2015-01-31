//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

protocol Utterance: class {
    func execute(_ input: TalkerInput, _ output: TalkerOutput, continuation: () -> ())
}