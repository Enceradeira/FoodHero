//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation


public class Script {
    private var _utterances: [Utterance] = []
    private let _context: TalkerContext = TalkerContext()

    public init(_ context: TalkerContext) {
        _context = context;
    }

    var utterances: [Utterance] {
        return _utterances
    }

    public func say(text: String) -> Script {
        return say(oneOf: [text])
    }

    public func say(oneOf texts: [String]) -> Script {
        _utterances.append(OutputUtterance(Choices(texts, _context)))
        return self
    }

    public func waitResponse(byInvoking invocation: () -> (), andContinuingWith continuation: ((response:String, script:Script) -> ())? = {
        r, s in }) -> Script {
        _utterances.append(ResponseUtterance(invocation, continuation!, _context))
        return self;
    }


}
