//
// Created by Jorg on 22/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class UserParameters: ConversationParameters {
    public let parameter: String
    public let modelAnswer: String

    public init(semanticId: String, parameter: String, modelAnswer: String) {
        self.parameter = parameter
        self.modelAnswer = modelAnswer
        super.init(semanticId: semanticId)
    }
}