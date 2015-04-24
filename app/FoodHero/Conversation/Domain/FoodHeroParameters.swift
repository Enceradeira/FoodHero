//
// Created by Jorg on 18/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class FoodHeroParameters: ConversationParameters {
    public let state: String?
    public let expectedUserUtterances: ExpectedUserUtterances?

    public init(semanticId: String, state: String?, expectedUserUtterances: ExpectedUserUtterances?) {
        self.state = state
        self.expectedUserUtterances = expectedUserUtterances
        super.init(semanticId:semanticId)
    }
}


