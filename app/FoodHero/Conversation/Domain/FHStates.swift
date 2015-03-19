//
// Created by Jorg on 19/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class FHStates: NSObject {
    public class func askForFoodPreference() -> String {
        return "askForFoodPreference"
    }

    public class func askForWhatToDoNext() -> String {
        return "askForWhatToDoNext"
    }

    public class func afterCantAccessLocationService() -> String {
        return "afterCantAccessLocationService"
    }

    public class func noRestaurantWasFound() -> String {
        return "noRestaurantWasFound"
    }

    public class func networkError() -> String {
        return "networkError"
    }

    public class func askForSuggestionFeedback() -> String {
        return "askForSuggestionFeedback"
    }
}
