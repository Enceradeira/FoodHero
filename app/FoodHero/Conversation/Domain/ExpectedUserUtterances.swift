//
// Created by Jorg on 23/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class ExpectedUserUtterances: NSObject, NSCoding {
    let _utterances: [String]

    public init(utterances: [String]) {
        _utterances = utterances;
    }

    var utterances: [String] {
        get {
            return _utterances
        }
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(_utterances, forKey: "_utterances");
    }

    public required init(coder aDecoder: NSCoder) {
        _utterances = aDecoder.decodeObjectForKey("_utterances") as! [String]
    }

    public override func isEqual(other: AnyObject?) -> Bool {
        if let other = other as? ExpectedUserUtterances {
            if _utterances != other._utterances {
                return false;
            }
            return true;
        }
        return false;
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
        let empty = TextAndLocation(text:"")

        let allPossibleUtterances = utterances + seperator + [
                // Following utterances are always possible 'All States'
                UserUtterances.occasionPreference(empty, text: "") as TalkerUtterance?,
                UserUtterances.cuisinePreference(empty, text: "") as TalkerUtterance?
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
                UserUtterances.suggestionFeedbackForLikeWithLocationRequest(dummyRestaurant, text: ""),
                UserUtterances.suggestionFeedbackForTooFarAway(dummyRestaurant, text: ""),
                UserUtterances.suggestionFeedbackForTheClosestNow(dummyRestaurant, text: ""),
                UserUtterances.suggestionFeedbackForTooExpensive(dummyRestaurant, text: ""),
                UserUtterances.suggestionFeedbackForTooCheap(dummyRestaurant, text: ""),
                UserUtterances.locationRequest(""),
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
        let empty = TextAndLocation(text:"")
        return modelAnswersFrom(
        [
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

    public class func whenAskedForProductFeedback() -> ExpectedUserUtterances {
        return ExpectedUserUtterances(utterances: [
                modelAnswerFrom(UserUtterances.wantsToGiveProductFeedback("")),
                modelAnswerFrom(UserUtterances.doesnWantToGiveProductFeedback(""))
        ])
    }
}
