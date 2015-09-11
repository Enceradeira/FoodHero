//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class OutputUtterance: Utterance {
    private let _definition: StringDefinition

    init(definition: StringDefinition, context:TalkerContext) {
        _definition = definition
    }

    override func executeWith(input: TalkerInput, output: TalkerOutput, continuation: () -> ()) {
        _definition.text.subscribeNext {
            obj in
            let def = obj as! StringDefinition.Result;
            let text = def.choises.getOne()
            let customData: AnyObject? = def.customData
            output.sendNext(TalkerUtterance(utterance: text, customData: customData), andNotifyMode: TalkerModes.Outputting)
            continuation()
        }
    }

    override var hasOutput : Bool {
        get{
            // produces output
            return true;
        }
    }
}