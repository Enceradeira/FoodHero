//
// Created by Jorg on 18/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class FoodHeroParameters: ConversationParameters {
    public let state: String?

    public override init(semanticId: String, state: String? = nil) {
        super.init(semanticId:semanticId)
        self.state = state
    }
}

