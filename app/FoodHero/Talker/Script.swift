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

    private func createOutputUtterance(texts: (StringDefinition) -> (StringDefinition)) -> OutputUtterance {
        let definition = StringDefinition(context: _context)
        texts(definition)
        return OutputUtterance(definition: definition)
    }


    public func say(oneOf texts: (StringDefinition) -> (StringDefinition)) -> Script {
        _utterances.append(createOutputUtterance(texts))
        return self
    }

    public func saySometimes(oneOf texts: (StringDefinition) -> (StringDefinition), withTag tag: String) -> Script {
        _utterances.append(OptionalUtterance(utterance: createOutputUtterance(texts), tag: tag, context: _context))
        return self
    }

    public func waitResponse(andContinueWith
                             continuation: ((TalkerUtterance, FutureScript) -> (FutureScript))? = {
        r, s in s.define {
            $0
        }
    },
                             catch: ((NSError, Script) -> Script)?
    ) -> Script {
        _utterances.append(ResponseUtterance(continuation!, catch, _context))
        return self;
    }

    public func chooseOne(from branches: [((FutureScript) -> (FutureScript))], withTag tag: String) -> Script {
        _utterances.append(Branch(tag: tag, branches: branches, context: _context))
        return self
    }

    public func continueWith(# continuation: ((FutureScript) -> (FutureScript)))->Script{
        _utterances.append(Continuation(continuation: continuation,context:_context))
        return self;
    }
}

