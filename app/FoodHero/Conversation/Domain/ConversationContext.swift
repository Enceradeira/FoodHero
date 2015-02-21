//
// Created by Jorg on 18/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class ConversationContext: NSObject {
    public let semanticId: String
    public let state: String?

    public init(semanticId: String, state: String? = nil) {
        self.semanticId = semanticId
        self.state = state
    }
}
