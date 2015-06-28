//
// Created by Jorg on 23/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class ExpectedUserUtterances: NSObject {
    let _utterances: [String]

    public init(utterances: [String]) {
        _utterances = utterances;
    }

    var utterances: [String] {
        get {
            return _utterances
        }
    }

    private class func modelAnswerFrom(utterance: TalkerUtterance) -> String {
        if let userParameter = (utterance.customData[0] as? UserParameters) {
            return userParameter.modelAnswer
        } else {
            return (utterance.customData[0] as! USuggestionFeedbackParameters).modelAnswer
        }
    }

    private class func modelAnswersFrom(utterances: [TalkerUtterance?]) -> ExpectedUserUtterances {
        let seperator: [TalkerUtterance?] = count(utterances) == 0 ? [] : [nil]
        let allPossibleUtterances = utterances + seperator + [
                // Following utterances are always possible 'All States'
                UserUtterances.occasionPreference("", text: "") as TalkerUtterance?,
                UserUtterances.cuisinePreference("", text: "") as TalkerUtterance?
        ]
        let modelAnswers = allPossibleUtterances.map {
            $0 == nil ? "" : self.modelAnswerFrom($0!)
        }
        return ExpectedUserUtterances(utterances: modelAnswers)
    }

    public class func whenAskedForFoodPreference() -> ExpectedUserUtterances {
        return modelAnswersFrom([])
    }

    public class func whenAskedForSuggestionFeedback(occasion: String) -> ExpectedUserUtterances {
        let dummyRestaurant = Restaurant()
        return modelAnswersFrom(
        [
                UserUtterances.suggestionFeedbackForLike(dummyRestaurant, text: ""),
                UserUtterances.suggestionFeedbackForDislike(dummyRestaurant, text: ""),
                UserUtterances.suggestionFeedbackForTooFarAway(dummyRestaurant, text: ""),
                UserUtterances.suggestionFeedbackForTheClosestNow(dummyRestaurant, text: ""),
                UserUtterances.suggestionFeedbackForTooExpensive(dummyRestaurant, text: ""),
                UserUtterances.suggestionFeedbackForTooCheap(dummyRestaurant, text: ""),
                nil, // creates a visible seperator on the UI
                UserUtterances.dislikesKindOfFood(""),
                UserUtterances.dislikesOccasion("", occasion: occasion),
                nil,
                UserUtterances.wantsToAbort("")
        ])
    }

    public class func whenAskedForWhatToDoNext() -> ExpectedUserUtterances {
        return modelAnswersFrom(
        [
                UserUtterances.wantsToStopConversation(""),
                UserUtterances.wantsToSearchForAnotherRestaurant("")
        ])
    }

    public class func whenAfterCantAccessLocationService() -> ExpectedUserUtterances {
        return modelAnswersFrom(
        [
                UserUtterances.tryAgainNow("")
        ])
    }

    public class func whenNoRestaurantWasFound() -> ExpectedUserUtterances {
        return modelAnswersFrom(
        [
                UserUtterances.cuisinePreference("", text: ""),
                UserUtterances.occasionPreference("", text: ""),
                nil, // creates a visible seperator on the UI
                UserUtterances.wantsToStartAgain(""),
                UserUtterances.wantsToAbort("")
        ])
    }

    public class func whenNetworkError() -> ExpectedUserUtterances {
        return modelAnswersFrom(
        [
                UserUtterances.tryAgainNow("")
        ])
    }

    public class func whenConversationEnded() -> ExpectedUserUtterances {
        return modelAnswersFrom(
        [
                UserUtterances.goodBye(""),
                UserUtterances.hello("")
        ])
    }

}
