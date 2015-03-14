//
// Created by Jorg on 12/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

extension Script {
    public func waitUserResponse(andContinueWith continuation: ((ConversationParameters, FutureScript) -> (FutureScript))) -> Script {
        return waitResponse(andContinueWith: {
            let parameter = $0.customData[0] as ConversationParameters
            return continuation(parameter, $1)
        }, catch:{ e,s in s})
    }
}