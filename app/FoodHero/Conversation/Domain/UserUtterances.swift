//
// Created by Jorg on 12/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class UserUtterances: NSObject {
    private class func createUtterance(semanticId: String, text: String, modelAnswer: String, parameter: TextAndLocation? = nil) -> TalkerUtterance {
        let textAndLocation = parameter == nil ? TextAndLocation(text: "", location: "") : parameter!
        let parameter = UserParameters(semanticId: semanticId, parameter: textAndLocation, modelAnswer: modelAnswer)

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
        let oocasionToDisplay = occasion.characters.count == 0 ? Occasions.snack() : occasion
        return createUtterance("U:DislikesOccasion", text: text, modelAnswer: "I don't want to have \(oocasionToDisplay)");
    }

    public class func wantsToSearchForAnotherRestaurant(text: String) -> TalkerUtterance {
        return createUtterance("U:WantsToSearchForAnotherRestaurant", text: text, modelAnswer: "Search for another restaurant");
    }

    public class func wantsToAbort(text: String) -> TalkerUtterance {
        return createUtterance("U:WantsToAbort", text: text, modelAnswer: "Forget about it");
    }

    public class func wantsToStartAgain(text: String) -> TalkerUtterance {
        return createUtterance("U:WantsToStartAgain", text: text, modelAnswer: "Let's start again");
    }

    public class func tryAgainNow(text: String) -> TalkerUtterance {
        return createUtterance("U:TryAgainNow", text: text, modelAnswer: "Try again");
    }

    public class func goodBye(text: String) -> TalkerUtterance {
        return createUtterance("U:GoodBye", text: text, modelAnswer: "Goodbye");
    }

    public class func cuisinePreference(parameter: TextAndLocation, text: String) -> TalkerUtterance {
        return createUtterance("U:CuisinePreference=\(parameter.text);\(parameter.location)", text: text,
                modelAnswer: "Search for Sushi in Tokyo", parameter: parameter);
    }

    public class func occasionPreference(parameter: TextAndLocation, text: String) -> TalkerUtterance {
        return createUtterance("U:OccasionPreference=\(parameter.text);\(parameter.location)", text: text,
                modelAnswer: "I want to have lunch", parameter: parameter);
    }

    public class func suggestionFeedbackForTooFarAway(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=tooFarAway", text: text,
                modelAnswer: "It's too far away", restaurant: restaurant)
    }

    public class func suggestionFeedbackForTheClosestNow(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=theClosestNow", text: text,
                modelAnswer: "Give me the closest", restaurant: restaurant)
    }

    public class func suggestionFeedbackForTooExpensive(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=tooExpensive", text: text,
                modelAnswer: "Is there something more affordable?", restaurant: restaurant)
    }

    public class func suggestionFeedbackForTooCheap(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=tooCheap", text: text,
                modelAnswer: "I want something nicer", restaurant: restaurant)
    }

    public class func suggestionFeedbackForDislike(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=Dislike", text: text,
                modelAnswer: "I don't like it", restaurant: restaurant)
    }

    public class func suggestionFeedbackForLike(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=Like", text: "<a href=''>\(text)</a>",
                modelAnswer: "I like it", restaurant: restaurant)
    }

    public class func suggestionFeedbackForLikeWithLocationRequest(restaurant: Restaurant, text: String) -> TalkerUtterance {
        return createUtterance("U:SuggestionFeedback=LikeWithLocationRequest", text: text,
                modelAnswer: "That sounds good. Where is it?", restaurant: restaurant)
    }

    public class func wantsToStopConversation(text: String) -> TalkerUtterance {
        return createUtterance("U:WantsToStopConversation", text: text, modelAnswer: "No");
    }

    public class func hello(text: String) -> TalkerUtterance {
        return createUtterance("U:Hello", text: text, modelAnswer: "Hello!");
    }

    public class func locationRequest(text: String) -> TalkerUtterance {
        return createUtterance("U:LocationRequest", text: text, modelAnswer: "Where is that restaurant?");
    }

    public class func wantsToGiveProductFeedback(text: String) -> TalkerUtterance {
        return createUtterance("U:ProductFeedback=Yes", text: text, modelAnswer: "Yes");
    }

    public class func doesnWantToGiveProductFeedback(text: String) -> TalkerUtterance {
        return createUtterance("U:ProductFeedback=No", text: text, modelAnswer: "No");
    }
}
