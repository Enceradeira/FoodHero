//
// Created by Jorg on 22/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class ConversationParameters: NSObject {
    public let semanticIdInclParameters: String

    public init(semanticId: String, state: String? = nil) {
        self.semanticIdInclParameters = semanticId
    }

    public func hasSemanticId(semanticId: String) -> Bool {
        return self.semanticIdInclParameters.rangeOfString(semanticId) != nil
    }
}


