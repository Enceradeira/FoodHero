//
// Created by Jorg on 22/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class UserParameters: ConversationParameters {
    public let parameter: String

    public init(semanticId: String, parameter: String) {
        self.parameter = parameter
        super.init(semanticId: semanticId)
    }
}