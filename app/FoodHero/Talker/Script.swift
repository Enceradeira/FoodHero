//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation


public class Script: NSObject {
    private var _utterances: [Utterance] = []
    private let _context: TalkerContext

    public init(context: TalkerContext) {
        _context = context;
    }

    var utterances: [Utterance] {
        return _utterances
    }

    public func say(oneOf texts: (StringDefinition)->(StringDefinition)) -> Script {
        let definition = StringDefinition(context:_context)
        texts(definition)

        _utterances.append(OutputUtterance(definition:definition))
        return self
    }

    public func waitResponse(andContinueWith continuation: ((response:String, script:Script) -> ())? = {
        r, s in }) -> Script {
        _utterances.append(ResponseUtterance(continuation!, _context))
        return self;
    }
}