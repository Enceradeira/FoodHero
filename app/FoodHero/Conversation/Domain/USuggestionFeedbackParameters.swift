//
// Created by Jorg on 24/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class USuggestionFeedbackParameters: ConversationParameters {
    private let _restaurant: Restaurant
    public let modelAnswer: String

    public init(semanticId: String, modelAnswer: String, restaurant: Restaurant) {
        _restaurant = restaurant
        self.modelAnswer = modelAnswer
        super.init(semanticId: semanticId)
    }

    public override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_restaurant, forKey: "_restaurant");
        aCoder.encodeObject(modelAnswer, forKey: "modelAnswer");
    }

    public required init(coder aDecoder: NSCoder) {
        _restaurant = aDecoder.decodeObjectForKey("_restaurant") as! Restaurant
        modelAnswer = aDecoder.decodeObjectForKey("modelAnswer") as! String
        super.init(coder: aDecoder)
    }

    public override func isEqual(other: AnyObject?) -> Bool {
        if let other = other as? USuggestionFeedbackParameters {
            if _restaurant != other._restaurant {
                return false;
            }
            if modelAnswer != modelAnswer{
                return false
            }
            return super.isEqual(other);
        }
        return false;
    }

    public var restaurant: Restaurant {
        get {
            return _restaurant
        }
    }
}
