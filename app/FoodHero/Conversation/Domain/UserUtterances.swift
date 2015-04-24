//
// Created by Jorg on 12/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class UserUtterances: NSObject {
    private class func createUtterance(semanticId: String, text: String, modelAnswer: String, parameter: String = "") -> TalkerUtterance {
        let parameter = UserParameters(semanticId: semanticId, parameter: parameter, modelAnswer: modelAnswer)

        return TalkerUtterance(utterance: text, customData: parameter)
    }

    private class func createUtterance(semanticId: String, text: String, modelAnswer: String, restaurant: Restaurant) -> TalkerUtterance {
        let parameter = USuggestionFeedbackParameters(semanticId: semanticId, modelAnswer: modelAnswer, restaurant: restaurant)
        return TalkerUtterance(utterance: text, customData: parameter)
    }

    public class func dislikesKindOfFood(text: String) -> TalkerUtterance {
        return createUtterance("U:DislikesKindOfFood", text: text, modelAnswer: "I don't like this kind of food");
    }

    public class func dislikesOccasion(text: String, occasion: String) -> TalkerUtterance {
        return createUtterance("U:DislikesOccasion", text: text, modelAnswer: "I don't want to have \(occasion)");
    }

    public class func wantsToSearchForAnotherRestaurant(text: String) -> TalkerUtterance {
        return createUtterance("U:WantsToSearchForAnotherRestaurant", text: text, modelAnswer: "Search for another restaurant");
    }

    public class func wantsToAbort(text: String) -> TalkerUtterance {
        return createUtterance("U:WantsToAbort", text: text, modelAnswer: "Forget about it");
    }

    public class func wantsToStartAgain(text: String) -> TalkerUtterance {
        return createUtterance("U:WantsToStartAgain", text: text, modelAnswer: "Start again");
    }

    public class func tryAgainNow(text: String) -> TalkerUtterance {
        return createUtterance("U:TryAgainNow", text: text, modelAnswer: "Try again");
    }

    public class func goodBye(text: String) -> TalkerUtterance {
        return createUtterance("U:GoodBye", text: text, modelAnswer: "Good Bye");
    }

    public class func cuisinePreference(parameter: String, text: String) -> TalkerUtterance {
        return createUtterance("U:CuisinePreference=\(parameter)", text: text,
                modelAnswer: "I'd rather have Sushi", parameter: parameter);
    }

    public class func occasionPreference(parameter: String, text: String) -> TalkerUtterance {
        return createUtterance("U:OccasionPreference=\(parameter)", text: text,
                modelAnswer: "I want to have Lunch", parameter: parameter);
    }

    public class func suggestionFeedbackForTooFarAway(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=tooFarAway", text: text,
                modelAnswer: "It's too far away", restaurant: restaurant)
    }

    public class func suggestionFeedbackForTooExpensive(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=tooExpensive", text: text,
                modelAnswer: "It's too expensive", restaurant: restaurant)
    }

    public class func suggestionFeedbackForTooCheap(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=tooCheap", text: text,
                modelAnswer: "It looks too cheap", restaurant: restaurant)
    }

    public class func suggestionFeedbackForDislike(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=Dislike", text: text,
                modelAnswer: "I don't like it", restaurant: restaurant)
    }

    public class func suggestionFeedbackForLike(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=Like", text: text,
                modelAnswer: "I like it", restaurant: restaurant)
    }

}
