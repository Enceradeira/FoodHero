//
// Created by Jorg on 26/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

public class ConversationAppServiceSpy: NSObject, IConversationAppService {
    public var NrCallsToStartWithFeedbackRequestTrue = 0
    public var NrCallsToStartWithFeedbackRequestFalse = 0
    public func startWithFeedbackRequest(isWithFeedbackRequest: Bool) {
        if isWithFeedbackRequest {
            NrCallsToStartWithFeedbackRequestTrue = NrCallsToStartWithFeedbackRequestTrue + 1
        } else {
            NrCallsToStartWithFeedbackRequestFalse = NrCallsToStartWithFeedbackRequestFalse + 1
        }
    }
}
