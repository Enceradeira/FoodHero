//
// Created by Jorg on 11/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class ConversationRepository: NSObject {
    private let _assembly: ApplicationAssembly
    private var _conversation: Conversation?

    public init(assembly: ApplicationAssembly) {
        _assembly = assembly
    }


    public func getForInput(input: RACSignal) -> Conversation {
        if (_conversation == nil) {
            _conversation = Conversation(input: input, assembly: _assembly)
        }
        return _conversation!
    }

    public func persist(){

    }
}
