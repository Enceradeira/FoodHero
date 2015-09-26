//
// Created by Jorg on 26/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

public class ConversationAppServiceSpy: NSObject, IConversationAppService {
    public var NrCallsToRequestUserFeedback = 0
    public func requestUserFeedback(){
        NrCallsToRequestUserFeedback = NrCallsToRequestUserFeedback + 1
    }
}
