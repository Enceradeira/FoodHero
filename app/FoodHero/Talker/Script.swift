//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation


public class Script: NSObject {
    private var _utterances: [IUtterance] = []
    internal let context: TalkerContext
    internal var engine: TalkerEngine!

    public init(talkerContext: TalkerContext) {
        context = talkerContext;
    }

    var utterances: [IUtterance] {
        return _utterances
    }

    private func createOutputUtterance(texts: (StringDefinition) -> (StringDefinition)) -> OutputUtterance {
        let definition = StringDefinition(context: context)
        texts(definition)
        return OutputUtterance(definition: definition, context: context)
    }

    public func say(oneOf texts: (StringDefinition) -> (StringDefinition)) -> Script {
        _utterances.append(createOutputUtterance(texts))
        return self
    }

    public func saySometimes(oneOf texts: (StringDefinition) -> (StringDefinition), withTag tag: String) -> Script {
        _utterances.append(OptionalUtterance(utterance: createOutputUtterance(texts), tag: tag, context: context))
        return self
    }

    public func waitResponse(andContinueWith
                             continuation: ((TalkerUtterance, FutureScript) -> (FutureScript))? = {
        r, s in s.define {
            $0
        }
    },
                             `catch`: ((NSError, Script) -> Script)?
    ) -> Script {
        _utterances.append(ResponseUtterance(continuation!, `catch`, context))
        return self;
    }

    public func chooseOne(from branches: [((FutureScript) -> (FutureScript))], withTag tag: String) -> Script {
        _utterances.append(Branch(tag: tag, branches: branches, context: context))
        return self
    }

    public func continueWith(continuation  continuation: ((FutureScript) -> (FutureScript))) -> Script {
        _utterances.append(Continuation(continuation: continuation, context: context))
        return self;
    }

    public func interrupt(with subscribt: Script) -> Script {
        subscribt.engine = engine
        engine.interrupt(with: subscribt)
        return self
    }
}

