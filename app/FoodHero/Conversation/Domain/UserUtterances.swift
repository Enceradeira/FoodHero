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

    private class func createUtterance(semanticId: String, text: String, restaurant: Restaurant) -> TalkerUtterance {
        let parameter = USuggestionFeedbackParameters(semanticId: semanticId, restaurant: restaurant)
        return TalkerUtterance(utterance: text, customData: parameter)
    }

    public class func dislikesKindOfFood(text: String) -> TalkerUtterance{
        return createUtterance("U:DislikesKindOfFood", text: text);
    }

    public class func wantsToSearchForAnotherRestaurant(text: String) -> TalkerUtterance {
        return createUtterance("U:WantsToSearchForAnotherRestaurant", text: text);
    }

    public class func wantsToAbort(text: String) -> TalkerUtterance {
        return createUtterance("U:WantsToAbort", text: text);
    }

    public class func wantsToStartAgain(text:String) -> TalkerUtterance{
        return createUtterance("U:WantsToStartAgain", text: text);
    }

    public class func tryAgainNow(text: String) -> TalkerUtterance {
        return createUtterance("U:TryAgainNow", text: text);
    }

    public class func goodBye(text: String) -> TalkerUtterance {
        return createUtterance("U:GoodBye", text: text);
    }

    public class func cuisinePreference(parameter: String, text: String) -> TalkerUtterance {
        return createUtterance("U:CuisinePreference=\(parameter)", text: text, parameter: parameter);
    }

    public class func suggestionFeedbackForTooFarAway(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=tooFarAway", text: text, restaurant: restaurant)
    }

    public class func suggestionFeedbackForTooExpensive(restaurant: Restaurant,  text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=tooExpensive", text: text, restaurant: restaurant)
    }

    public class func suggestionFeedbackForTooCheap(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=tooCheap", text: text, restaurant: restaurant)
    }

    public class func suggestionFeedbackForDislike(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=Dislike", text: text, restaurant: restaurant)
    }

    public class func suggestionFeedbackForLike(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=Like", text: text, restaurant: restaurant)
    }
}
