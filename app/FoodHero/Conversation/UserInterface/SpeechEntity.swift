//
// Created by Jorg on 29/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class SpeechEntity:NSObject {
    let type: String
    let value: String

    init(type: String, value: String) {
        self.type = type
        self.value = value
    }
}
