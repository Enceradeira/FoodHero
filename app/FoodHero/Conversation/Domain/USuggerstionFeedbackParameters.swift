//
// Created by Jorg on 24/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class USuggerstionFeedbackParameters: ConversationParameters {
    private let _restaurant: Restaurant
    private let _currentUserLocation: CLLocation
    public init(semanticId: String, state: String, restaurant: Restaurant, currentUserLocation location: CLLocation) {
        _restaurant = restaurant;
        _currentUserLocation = location
        super.init(semanticId: semanticId)
    }

    public var restaurant: Restaurant {
        get {
            return _restaurant;
        }
    }

    public var currentUserLocation: CLLocation {
        get {
            return _currentUserLocation;
        }
    }
}
