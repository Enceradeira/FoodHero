//
// Created by Jorg on 22/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class UserParameters: ConversationParameters {
    public let parameter: TextAndLocation
    public let modelAnswer: String

    public init(semanticId: String, parameter: TextAndLocation, modelAnswer: String) {
        self.parameter = parameter
        self.modelAnswer = modelAnswer
        super.init(semanticId: semanticId)
    }

    public override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(parameter, forKey: "parameter");
        aCoder.encodeObject(modelAnswer, forKey: "modelAnswer");
    }

    public required init(coder aDecoder: NSCoder) {
        parameter = aDecoder.decodeObjectForKey("parameter") as! TextAndLocation
        modelAnswer = aDecoder.decodeObjectForKey("modelAnswer") as! String
        super.init(coder: aDecoder)
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        if let other = object as? UserParameters {
            return parameter == other.parameter && modelAnswer == other.modelAnswer
        } else {
            return false
        }
    }
}