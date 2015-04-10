//
// Created by Jorg on 24/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class OutputUtterance: Utterance {
    private let _definition: StringDefinition

    init(definition: StringDefinition) {
        _definition = definition
    }

    func execute(input: TalkerInput, _ output: TalkerOutput, _ continuation: () -> ()) {
        _definition.text.subscribeNext {
            obj in
            let def = obj as! StringDefinition.Result;
            let text = def.choises.getOne()
            let customData = def.customData
            output.sendNext(TalkerUtterance(utterance: text, customData: customData), andNotifyMode: TalkerModes.Outputting)
            continuation()
        }
    }
}