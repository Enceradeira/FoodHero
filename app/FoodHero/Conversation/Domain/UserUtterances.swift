//
// Created by Jorg on 12/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class UserUtterances: NSObject {
    private class func createUtterance(semanticId: String, text: String, parameter: String = "") -> TalkerUtterance {
        let parameter = UserParameters(semanticId: semanticId, parameter: parameter)
        return TalkerUtterance(utterance: text, customData: parameter)
    }

    private class func createUtterance(semanticId: String, text: String, restaurant: Restaurant, currentUserLocation: CLLocation) -> TalkerUtterance {
        let parameter = USuggestionFeedbackParameters(semanticId: semanticId, restaurant: restaurant, currentUserLocation: currentUserLocation)
        return TalkerUtterance(utterance: text, customData: parameter)
    }

    class func wantsToSearchForAnotherRestaurant(text: String) -> TalkerUtterance {
        return createUtterance("U:WantsToSearchForAnotherRestaurant", text: text);
    }

    class func wantsToAbort(text: String) -> TalkerUtterance {
        return createUtterance("U:WantsToAbort", text: text);
    }

    class func tryAgainNow(text: String) -> TalkerUtterance {
        return createUtterance("U:TryAgainNow", text: text);
    }

    class func goodBye(text: String) -> TalkerUtterance {
        return createUtterance("U:GoodBye", text: text);
    }

    class func cuisinePreference(parameter: String, text: String) -> TalkerUtterance {
        return createUtterance("U:CuisinePreference=\(parameter)", text: text, parameter: parameter);
    }

    class func suggestionFeedbackForTooFarAway(restaurant: Restaurant, currentUserLocation: CLLocation, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=tooFarAway", text: text, restaurant: restaurant, currentUserLocation: currentUserLocation)
    }

    class func suggestionFeedbackForTooExpensive(restaurant: Restaurant, currentUserLocation: CLLocation, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=tooExpensive", text: text, restaurant: restaurant, currentUserLocation: currentUserLocation)
    }

    class func suggestionFeedbackForTooCheap(restaurant: Restaurant, currentUserLocation: CLLocation, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=tooCheap", text: text, restaurant: restaurant, currentUserLocation: currentUserLocation)
    }

    class func suggestionFeedbackForNotLikingAtAll(restaurant: Restaurant, currentUserLocation: CLLocation, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=Dislike", text: text, restaurant: restaurant, currentUserLocation: currentUserLocation)
    }

    class func suggestionFeedbackForLiking(restaurant: Restaurant, currentUserLocation: CLLocation, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=Like", text: text, restaurant: restaurant, currentUserLocation: currentUserLocation)
    }
}
