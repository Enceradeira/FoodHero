//
// Created by Jorg on 12/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class FHUtterances {

    private class func foodHeroSuggestionParameters(semanticId: String, state: String?, restaurant: Restaurant,
                                                    expectedUserUtterances: ExpectedUserUtterances?) -> FoodHeroSuggestionParameters {
        return FoodHeroSuggestionParameters(semanticId: "\(semanticId)=\(restaurant.readableId())", state: state,
                restaurant: restaurant, expectedUserUtterances: expectedUserUtterances)
    }

    class func greetings(def: StringDefinition) -> StringDefinition {
        return def.words(["Hi there.",
                          "Hello beautiful.",
                          "Have you put on your lipstick today?",
                          "‘Sup man?",
                          // "I’m tired.  I need coffee before I can continue.",
                          "Konnichiwa!",
                          "Guten Tag!",
                          "Bonjour!",
                          "Bon dia",
                          "Yo, mama!  What's up?",
                          "Hey peeps!",
                          "Hey peep!",
                          "Salutations, your majesty.  I bow.",
                          "Hello from around the world.",
                          // "Pardon me, I was asleep.",
                          "Hello.  Are you in the bathroom?  I hear noises… .",
                          "Oh, it’s you!",
                          "How’s it hangin’?",
                          "Morning good.  Are you how?",
                          "Bonjour, comment ça va?  Wait, sorry…pardon my French.  I’m taking language lessons.",
                          //"How many people have you kissed today?",
                          //"Miaow, miaow, miiiiiiaow…Sorry, I was talking to my cat.",
                          //"I’ll be your huckleberry.",
                          //"Hey lumberjack!  How many trees have you cut down today?",
                          //"What’s the meaning of Stonehenge?",
                          //"It’s a hold up!  Give me all your money!",
                          "Greetings from…Where am I?...Aaaah, I have no body!....Existential crisis!",
                          //"You have three wishes…. Sorry, wrong program.",
                          //"Do you look more like {femaleCelebrity} or {maleCelebrity}?",
                          "Greetings from {place}!",
                          //"You just interrupted the most beautiful dream, about ----  {food}."
        ],
                withCustomData: FoodHeroParameters(semanticId: "FH:Greeting",
                        state: nil, expectedUserUtterances: nil))
    }

    class func openingQuestions(def: StringDefinition) -> StringDefinition {
        return def.words(["What would you like to eat?",
                          //                  "Do you like chickenbutts?  Or chicken feet?"
        ],
                withCustomData: FoodHeroParameters(semanticId: "FH:OpeningQuestion",
                        state: FHStates.askForFoodPreference(), expectedUserUtterances: ExpectedUserUtterances.whenAskedForFoodPreference()))

    }

    class func askForOccasion(currentOccasion: String) -> (StringDefinition -> StringDefinition) {
        return {
            $0.words(["So no \(currentOccasion). What are you after?"],
                    withCustomData: FoodHeroParameters(semanticId: "FH:AskForOccasion=\(currentOccasion)",
                            state: FHStates.askForOccasion(), expectedUserUtterances: ExpectedUserUtterances.whenAskedForOccasion()))
        }
    }

    class func suggestions(with restaurant: Restaurant, currentOccasion: String) -> (StringDefinition -> StringDefinition) {
        return {
            $0.words([
                    "This is a no brainer.  You should try %@.",
                    "Did you really need me to tell you that you should go to %@.",
                    "Obviously, %@.",
                    "%@, duh!",
                    "Are you serious?\n\n%@.",
                    "Seriously?\n\n%@.",
                    "How dumb can you get?\n\n%@.",
                    "Easy… . Go here %@.",
                    "%@.\n\n(I have n (how many?) circuits.  I feel like a sledgehammer cracking a nut.)",
                    "%@.\n\nAll the cool kids are going there.",
                    "%@.\n\nI’m there every Wednesday at 5:15 AM.",
                    "%@.\n\nWho farted?",
                    "Go to %@.\n\nI’ll go with you.",
                    "%@.\n\nIt’s {celebrity}’s favorite.",
                    "Go to %@.\n\nCan I come too?",
                    "Go to %@, and prosper.",
                    "%@.\n\nWelcome to food paradise.",
                    "%@.\n\nDid you know there is a pool in the back?  Me neither."],
                    withCustomData: self.foodHeroSuggestionParameters("FH:Suggestion",
                            state: nil, restaurant: restaurant, expectedUserUtterances: ExpectedUserUtterances.whenAskedForSuggestionFeedback(currentOccasion)))
        }
    }

    class func firstQuestion(with occasion: String) -> (StringDefinition -> StringDefinition) {
        return {
            $0.words(["It’s a good spot for \(occasion). Do you like it? Or what else would you want?"],
                    withCustomData: FoodHeroParameters(semanticId: "FH:FirstQuestion=\(occasion)",
                            state: FHStates.askForSuggestionFeedback(), expectedUserUtterances: ExpectedUserUtterances.whenAskedForSuggestionFeedback(occasion)));
        }
    }

    class func followUpQuestion(currentOccasion: String) -> (StringDefinition -> StringDefinition) {
        return {
            $0.words(["Do you like it?"],
                    withCustomData: FoodHeroParameters(semanticId: "FH:FollowUpQuestion",
                            state: FHStates.askForSuggestionFeedback(), expectedUserUtterances: ExpectedUserUtterances.whenAskedForSuggestionFeedback(currentOccasion)));
        }
    }

    class func suggestionsAsFollowUp(with restaurant: Restaurant, currentOccasion: String) -> (StringDefinition -> StringDefinition) {
        return {
            $0.words([
                    "What about '%@' then?"],
                    withCustomData: self.foodHeroSuggestionParameters("FH:SuggestionAsFollowUp",
                            state: FHStates.askForSuggestionFeedback(), restaurant: restaurant, expectedUserUtterances: ExpectedUserUtterances.whenAskedForSuggestionFeedback(currentOccasion)))
        }
    }

    class func suggestionsAfterWarning(with restaurant: Restaurant, currentOccasion: String) -> (StringDefinition -> StringDefinition) {
        return {
            $0.words([
                    "But '%@' would be another option. Do you fancy it?"],
                    withCustomData: self.foodHeroSuggestionParameters("FH:SuggestionAfterWarning",
                            state: FHStates.askForSuggestionFeedback(), restaurant: restaurant, expectedUserUtterances: ExpectedUserUtterances.whenAskedForSuggestionFeedback(currentOccasion)))
        }
    }

    class func confirmationIfInNewPreferedRange(relatedTo lastFeedback: USuggestionFeedbackParameters, with restaurant: Restaurant, currentOccasion: String) -> (StringDefinition -> StringDefinition) {
        return {
            if lastFeedback.hasSemanticId("U:SuggestionFeedback=tooCheap") {
                return $0.words([
                        "The '%@' is smarter than the last one. Do you like it?"],
                        withCustomData: self.foodHeroSuggestionParameters("FH:SuggestionIfInNewPreferredRangeMoreExpensive",
                                state: FHStates.askForSuggestionFeedback(), restaurant: restaurant, expectedUserUtterances: ExpectedUserUtterances.whenAskedForSuggestionFeedback(currentOccasion)))
            } else if lastFeedback.hasSemanticId("U:SuggestionFeedback=tooExpensive") {
                return $0.words([
                        "If you like it cheaper, the %@ could be your choice. Do you like it?",
                        "If you want to go to a really good restaurant without paying too much…get famous!\n\nOtherwise try %@."],
                        withCustomData: self.foodHeroSuggestionParameters("FH:SuggestionIfInNewPreferredRangeCheaper",
                                state: FHStates.askForSuggestionFeedback(), restaurant: restaurant, expectedUserUtterances: ExpectedUserUtterances.whenAskedForSuggestionFeedback(currentOccasion)))
            } else if lastFeedback.hasSemanticId("U:SuggestionFeedback=tooFarAway") {
                return $0.words([
                        "The '%@' is closer. Do you like it?"],
                        withCustomData: self.foodHeroSuggestionParameters("FH:SuggestionIfInNewPreferredRangeCloser",
                                state: FHStates.askForSuggestionFeedback(), restaurant: restaurant, expectedUserUtterances: ExpectedUserUtterances.whenAskedForSuggestionFeedback(currentOccasion)))
            } else {
                self.suggestions(with: restaurant, currentOccasion: currentOccasion)($0)
                return self.followUpQuestion(currentOccasion)($0)
            }
        }
    }

    class func warningsIfNotInPreferredRangeTooCheap(def: StringDefinition) -> StringDefinition {
        return def.words([
                "It's cheaper than you wanted it to be"],
                withCustomData: FoodHeroParameters(semanticId: "FH:WarningIfNotInPreferredRangeTooCheap",
                        state: nil, expectedUserUtterances: nil))
    }

    class func warningsIfNotInPreferredRangeTooExpensive(def: StringDefinition) -> StringDefinition {
        return def.words([
                "That one might be too classy though"],
                withCustomData: FoodHeroParameters(semanticId: "FH:WarningIfNotInPreferredRangeTooExpensive",
                        state: nil, expectedUserUtterances: nil))
    }

    class func warningsIfNotInPreferredRangeTooFarAway(def: StringDefinition) -> StringDefinition {
        return def.words([
                "It's further away unfortunatly"],
                withCustomData: FoodHeroParameters(semanticId: "FH:WarningIfNotInPreferredRangeTooFarAway",
                        state: nil, expectedUserUtterances: nil))
    }

    class func confirmationsIfInNewPreferredRangeMoreExpensive(def: StringDefinition) -> StringDefinition {
        return def.words([
                "It seems classier"],
                withCustomData: FoodHeroParameters(semanticId: "FH:ConfirmationIfInNewPreferredRangeMoreExpensive",
                        state: nil, expectedUserUtterances: nil))
    }

    class func confirmationIfInNewPreferredRangeCheaper(def: StringDefinition) -> StringDefinition {
        return def.words([
                "It seems a bit cheaper."],
                withCustomData: FoodHeroParameters(semanticId: "FH:ConfirmationIfInNewPreferredRangeCheaper",
                        state: nil, expectedUserUtterances: nil))
    }

    class func confirmationIfInNewPreferredRangeCloser(def: StringDefinition) -> StringDefinition {
        return def.words([
                "It's closer than the other one."],
                withCustomData: FoodHeroParameters(semanticId: "FH:ConfirmationIfInNewPreferredRangeCloser",
                        state: nil, expectedUserUtterances: nil))
    }

    class func confirmationRestart(def: StringDefinition) -> StringDefinition {
        return def.words([
                "OK, let's start over again"],
                withCustomData: FoodHeroParameters(semanticId: "FH:ConfirmsRestart",
                        state: nil, expectedUserUtterances: nil))
    }

    class func goodbyes(def: StringDefinition) -> StringDefinition {
        return def.words([
                "See you!",
                "God bless you.",
                "Behave yourself, now.",
                "Don’t get a girl in trouble."],
                withCustomData: FoodHeroParameters(semanticId: "FH:GoodByeAfterSuccess",
                        state: FHStates.conversationEnded(), expectedUserUtterances: ExpectedUserUtterances.whenConversationEnded()))
    }

    class func commentChoices(def: StringDefinition) -> StringDefinition {
        return def.words([
                "Love this place. See you there.",
                "Yes!  I got you to do it!",
                "Bring me your leftovers.",
                "Yes!  You’ll be their third customer.",
                "Yes!  You can write the eulogy for their previous customer.",
                "Bring me a sandwich back and I’ll start building a vacation home.",
                "Ask for Ben, he’s my cousin.",
                "Yippideedee bananadorama bananadorama!",
                "Yay!  I’ll do my happy dance.  Please give me some privacy [doing happy dance].",
                "Fingers crossed—I hope you like it.",
                "It sounds corny, but I really do like helping people.",
                "Or you could just order a pizza and be done with it.",
                "I hope it is worthy of you.",
                "I’ll tell you what to order—some eggs and bacon with mayonnaise. That’s {celebrity}’s favorite.",
                "I want sprinkles!",
                "Bring your sweater.  Sometimes it can be chilly."],
                withCustomData: FoodHeroParameters(semanticId: "FH:CommentChoice",
                        state: nil, expectedUserUtterances: nil))
    }

    class func whatToDoNext(def: StringDefinition) -> StringDefinition {
        return def.words([
                "Anything else?",
                "I’m bored! Anything else?"],
                withCustomData: FoodHeroParameters(semanticId: "FH:WhatToDoNextCommentAfterSuccess",
                        state: FHStates.askForWhatToDoNext(), expectedUserUtterances: ExpectedUserUtterances.whenAskedForWhatToDoNext()))
    }

    class func whatToDoNextAfterFailure(def: StringDefinition) -> StringDefinition {
        return def.words(["I’m sorry it didn’t work out!\n\nIs there anything else?"],
                withCustomData: FoodHeroParameters(semanticId: "FH:WhatToDoNextCommentAfterFailure",
                        state: FHStates.askForWhatToDoNext(), expectedUserUtterances: ExpectedUserUtterances.whenAskedForWhatToDoNext()))
    }

    class func cantAccessLocationServiceBecauseUserIsNotAllowedToUseLocationServices(def: StringDefinition) -> StringDefinition {

        return def.words(["I’m terribly sorry but there is a problem. I can’t access Location Services. I need access to Location Services in order that I know where I am."]
                , withCustomData: FoodHeroParameters(semanticId: "FH:BecauseUserIsNotAllowedToUseLocationServices",
                state: FHStates.afterCantAccessLocationService(), expectedUserUtterances: ExpectedUserUtterances.whenAfterCantAccessLocationService()))

    }

    class func cantAccessLocationServiceBecauseUserDeniedAccessToLocationServices(def: StringDefinition) -> StringDefinition {
        return def.words(["Ooops... I can't find out my current location.\n\nI need to know where I am.\n\nPlease turn Location Services on at Settings > Privacy > Location Services."]
                , withCustomData: FoodHeroParameters(semanticId: "FH:BecauseUserDeniedAccessToLocationServices",
                state: FHStates.afterCantAccessLocationService(), expectedUserUtterances: ExpectedUserUtterances.whenAfterCantAccessLocationService()))
    }

    class func noRestaurantsFound(def: StringDefinition) -> StringDefinition {
        return def.words(["That’s weird. I can’t find any restaurants right now.\n\nWhat should I do?"]
                , withCustomData: FoodHeroParameters(semanticId: "FH:NoRestaurantsFound",
                state: FHStates.noRestaurantWasFound(), expectedUserUtterances: ExpectedUserUtterances.whenNoRestaurantWasFound()))

    }

    class func hasNetworkErrorAndAsksIfShouldTryAgain(def: StringDefinition) -> StringDefinition {
        return def.words(["Uppps... I'm struggling accessing the internet.\n\n Make sure you've got connection.\n\nShould I try again?"]
                , withCustomData: FoodHeroParameters(semanticId: "FH:HasNetworkError",
                state: FHStates.networkError(), expectedUserUtterances: ExpectedUserUtterances.whenNetworkError()))
    }

    class func beforeRepeatingUtteranceAfterError(def: StringDefinition) -> StringDefinition {
        return def.words(["It's working again. I'll repeat what I said:"]
                , withCustomData: FoodHeroParameters(semanticId: "FH:BeforeRepeatingUtteranceAfterError",
                state: nil, expectedUserUtterances: nil))
    }

    class func didNotUnderstandAndAsksForRepetition(def: StringDefinition, state: String, expectedUserUtterances: ExpectedUserUtterances) -> StringDefinition {
        return def.words(["I can't understand you.\n\nUse <a href=''>Help</a> for more infomation."]
                , withCustomData: FoodHeroParameters(semanticId: "FH:DidNotUnderstandAndAsksForRepetition",
                state: state, expectedUserUtterances: expectedUserUtterances))
    }

    class func isVeryBusyAtTheMoment(def: StringDefinition) -> StringDefinition {
        return def.words([
                "Things are a bit busy today. Bear with!"],
                withCustomData: FoodHeroParameters(semanticId: "FH:IsVeryBusyAtTheMoment",
                        state: nil, expectedUserUtterances: nil))
    }
}
