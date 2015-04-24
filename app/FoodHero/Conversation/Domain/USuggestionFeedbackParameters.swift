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

    public var restaurant: Restaurant {
        get {
            return _restaurant
        }
    }
}
