//
// Created by Jorg on 09/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class ConversationScript: Script {

    let _conversation: Conversation
    let _search: RestaurantSearch
    let _locationService: LocationService

    public init(context context: TalkerContext, conversation: Conversation, search: RestaurantSearch, locationService: LocationService) {
        _conversation = conversation
        _search = search
        _locationService = locationService

        super.init(context: context)

        say(oneOf: greetings)
        repeat({
            $0.repeat({
                $0.say(oneOf: self.openingQuestions).finish()
                $0.repeat({
                    return $0.waitResponse(andContinueWith: self.searchRestaurant).finish()
                }, until: self.userResponseIs("U:SuggestionFeedback=Like")).finish()
                $0.say(oneOf: self.commentChoices).finish()
                $0.say(oneOf: self.whatToDoNext).finish()
                $0.waitResponse().finish()
                return $0
            }, until: self.userResponseIs("U:GoodBye"))
            $0.say(oneOf: self.goodbyes)
            return $0.waitResponse().finish()
        }, until: { false })
        .finish()
    }

    func userResponseIs(semanticId: String) -> () -> Bool {
        return {
            let lastResponse = self._conversation.lastUserResponse()
            return lastResponse != nil && lastResponse!.hasSemanticId(semanticId)
        }
    }

    func goodbyes(def: StringDefinition) -> StringDefinition {
        return def.words([
                "See you!",
                "God bless you.",
                "Behave yourself, now.",
                "Don’t get a girl in trouble."],
                withCustomData: FoodHeroParameters(semanticId: "FH:GoodByeAfterSuccess", state: "afterGoodByeAfterSuccess"))
    }

    func commentChoices(def: StringDefinition) -> StringDefinition {
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
                withCustomData: FoodHeroParameters(semanticId: "FH:CommentChoice", state: nil))
    }

    func whatToDoNext(def: StringDefinition) -> StringDefinition {
        return def.words([
                "Anything else?",
                "I’m bored! Anything else?"],
                withCustomData: FoodHeroParameters(semanticId: "FH:WhatToDoNextCommentAfterSuccess", state: "askForWhatToDoNext"))
    }

    func openingQuestions(def: StringDefinition) -> StringDefinition {
        return def.words(["What kind of food would you like to eat?",
                          "Do you like chickenbutts?  Or chicken feet?"],
                withCustomData: FoodHeroParameters(semanticId: "FH:OpeningQuestion", state: "askForFoodPreference"))

    }

    func greetings(def: StringDefinition) -> StringDefinition {
        return def.words(["Hi there.",
                          "Hello beautiful.",
                          "Have you put on your lipstick today?",
                          "‘Sup man?",
                          "I’m tired.  I need coffee before I can continue.",
                          "Konnichiwa!",
                          "Guten Tag!",
                          "Bonjour!",
                          "Bon dia",
                          "Yo, mama!  What's up?",
                          "Hey peeps!",
                          "Hey peep!",
                          "Salutations, your majesty.  I bow.",
                          "Hello from around the world.",
                          "Pardon me, I was asleep.",
                          "Hello.  Are you in the bathroom?  I hear noises… .",
                          "Oh, it’s you!",
                          "How’s it hangin’?",
                          "Morning good.  Are you how?",
                          "Bonjour, comment ça va?  Wait, sorry…pardon my French.  I’m taking language lessons.",
                          "How many people have you kissed today?",
                          "Miaow, miaow, miiiiiiaow…Sorry, I was talking to my cat.",
                          "I’ll be your huckleberry.",
                          "Hey lumberjack!  How many trees have you cut down today?",
                          "What’s the meaning of Stonehenge?",
                          "It’s a hold up!  Give me all your money!",
                          "Greetings from…Where am I?...Aaaah, I have no body!....Existential crisis!",
                          "You have three wishes…. Sorry, wrong program.",
                          "Do you look more like {femaleCelebrity} or {maleCelebrity}?",
                          "Greetings from {place}!",
                          "You just interrupted the most beautiful dream, about ----  {food}."],
                withCustomData: FoodHeroParameters(semanticId: "FH:Greeting", state: nil))
    }

    func suggestions(with restaurant: Restaurant) -> (StringDefinition -> StringDefinition) {
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
                    withCustomData: FoodHeroSuggestionParameters(semanticId: "FH:Suggestion=\(restaurant.readableId())", state: "askForSuggestionFeedback", restaurant: restaurant))
        }
    }

    func suggestionsAsFollowUp(with restaurant: Restaurant) -> (StringDefinition -> StringDefinition) {
        return {
            $0.words([
                    "What about '%@' then?"],
                    withCustomData: FoodHeroSuggestionParameters(semanticId: "FH:SuggestionAsFollowUp=\(restaurant.readableId())", state: "askForSuggestionFeedback", restaurant: restaurant))
        }
    }

    func suggestionsWithComment(relatedTo lastFeedback: USuggestionFeedbackParameters, with restaurant: Restaurant) -> (StringDefinition -> StringDefinition) {
        return {
            FoodHeroSuggestionParameters(semanticId: "FH:Suggestion=\(restaurant.readableId())", state: "askForSuggestionFeedback", restaurant: restaurant)
            if lastFeedback.hasSemanticId("U:SuggestionFeedback=tooCheap") {
                return $0.words([
                        "The '%@' is smarter than the last one"],
                        withCustomData: FoodHeroSuggestionParameters(semanticId: "FH:SuggestionWithConfirmationIfInNewPreferredRangeMoreExpensive=\(restaurant.readableId())", state: "askForSuggestionFeedback", restaurant: restaurant))
            } else if lastFeedback.hasSemanticId("U:SuggestionFeedback=tooExpensive") {
                return $0.words([
                        "If you like it cheaper, the %@ could be your choice",
                        "If you want to go to a really good restaurant without paying too much…get famous!\n\nOtherwise try %@."],
                        withCustomData: FoodHeroSuggestionParameters(semanticId: "FH:SuggestionWithConfirmationIfInNewPreferredRangeCheaper=\(restaurant.readableId())", state: "askForSuggestionFeedback", restaurant: restaurant))
            } else if lastFeedback.hasSemanticId("U:SuggestionFeedback=tooFarAway") {
                return $0.words([
                        "The '%@' is closer"],
                        withCustomData: FoodHeroSuggestionParameters(semanticId: "FH:SuggestionWithConfirmationIfInNewPreferredRangeCloser=\(restaurant.readableId())", state: "askForSuggestionFeedback", restaurant: restaurant))
            } else {
                return self.suggestions(with: restaurant)($0)
            }
        }
    }

    func suggestionsAfterWarning(with restaurant: Restaurant) -> (StringDefinition -> StringDefinition) {
        return {
            $0.words([
                    "But '%@' would be another option"],
                    withCustomData: FoodHeroSuggestionParameters(semanticId: "FH:SuggestionAfterWarning=\(restaurant.readableId())", state: "askForSuggestionFeedback", restaurant: restaurant))
        }
    }

    func warningsIfNotInPreferredRangeTooCheap(def: StringDefinition) -> StringDefinition {
        return def.words([
                "It's cheaper than you wanted it to be"],
                withCustomData: FoodHeroParameters(semanticId: "FH:WarningIfNotInPreferredRangeTooCheap", state: nil))
    }

    func warningsIfNotInPreferredRangeTooExpensive(def: StringDefinition) -> StringDefinition {
        return def.words([
                "That one might be too classy though"],
                withCustomData: FoodHeroParameters(semanticId: "FH:WarningIfNotInPreferredRangeTooExpensive", state: nil))
    }

    func warningsIfNotInPreferredRangeTooFarAway(def: StringDefinition) -> StringDefinition {
        return def.words([
                "It's further away unfortunatly"],
                withCustomData: FoodHeroParameters(semanticId: "FH:WarningIfNotInPreferredRangeTooFarAway", state: nil))
    }

    func confirmationsIfInNewPreferredRangeMoreExpensive(def: StringDefinition) -> StringDefinition {
        return def.words([
                "It seems classier"],
                withCustomData: FoodHeroParameters(semanticId: "FH:ConfirmationIfInNewPreferredRangeMoreExpensive", state: nil))
    }

    func confirmationIfInNewPreferredRangeCheaper(def: StringDefinition) -> StringDefinition {
        return def.words([
                "It seems a bit cheaper."],
                withCustomData: FoodHeroParameters(semanticId: "FH:ConfirmationIfInNewPreferredRangeCheaper", state: nil))
    }

    func confirmationIfInNewPreferredRangeCloser(def: StringDefinition) -> StringDefinition {
        return def.words([
                "It's closer than the other one."],
                withCustomData: FoodHeroParameters(semanticId: "FH:ConfirmationIfInNewPreferredRangeCloser", state: nil))
    }

    func confirmations(def: StringDefinition) -> StringDefinition {
        return def.words([
                "What do you think?"],
                withCustomData: FoodHeroParameters(semanticId: "FH:Confirmation", state: nil))
    }

    func processSearchResult(result: AnyObject, withScript script: Script) -> (Script) {
        let restaurant = result as Restaurant
        let negativesFeedback = self._conversation.negativeUserFeedback()!
        let lastFeedback = (negativesFeedback.count > 0 ? negativesFeedback.last : nil) as USuggestionFeedbackParameters?
        let lastSuggestionWarning = self._conversation.lastSuggestionWarning()

        if lastFeedback != nil && (lastFeedback?.restaurant) != nil {
            let searchPreference = self._conversation.currentSearchPreference()
            let priceRange = searchPreference.priceRange
            if priceRange.min > restaurant.priceLevel
                    && (lastSuggestionWarning == nil || !lastSuggestionWarning.hasSemanticId("FH:WarningIfNotInPreferredRangeTooCheap")) {
                script.say(oneOf: self.warningsIfNotInPreferredRangeTooCheap)
                script.say(oneOf: self.suggestionsAfterWarning(with: restaurant))
            } else if priceRange.max < restaurant.priceLevel
                    && (lastSuggestionWarning == nil || !lastSuggestionWarning.hasSemanticId("FH:WarningIfNotInPreferredRangeTooExpensive")) {
                script.say(oneOf: self.warningsIfNotInPreferredRangeTooExpensive)
                script.say(oneOf: self.suggestionsAfterWarning(with: restaurant))
            } else if searchPreference.distanceRange.max < restaurant.location.distanceFromLocation(self._locationService.lastKnownLocation())
                    && (lastSuggestionWarning == nil || !lastSuggestionWarning.hasSemanticId("FH:WarningIfNotInPreferredRangeTooFarAway")) {
                script.say(oneOf: self.warningsIfNotInPreferredRangeTooFarAway)
                script.say(oneOf: self.suggestionsAfterWarning(with: restaurant))
            } else {
                script.chooseOne(from: [
                        {
                            return $0.say(oneOf: self.suggestions(with: restaurant)).finish()
                        },
                        {
                            $0.say(oneOf: self.suggestionsAsFollowUp(with: restaurant))
                            if lastFeedback!.hasSemanticId("U:SuggestionFeedback=tooCheap") {
                                return $0.saySometimes(oneOf: self.confirmationsIfInNewPreferredRangeMoreExpensive, withTag: RandomizerTagsConfirmationIfInNewPreferredRange).finish()
                            } else if lastFeedback!.hasSemanticId("U:SuggestionFeedback=tooExpensive") {
                                return $0.saySometimes(oneOf: self.confirmationIfInNewPreferredRangeCheaper, withTag: RandomizerTagsConfirmationIfInNewPreferredRange).finish()
                            } else if lastFeedback!.hasSemanticId("U:SuggestionFeedback=tooFarAway") {
                                return $0.saySometimes(oneOf: self.confirmationIfInNewPreferredRangeCloser, withTag: RandomizerTagsConfirmationIfInNewPreferredRange).finish()
                            }
                            return $0.finish()

                        },
                        {
                            $0.say(oneOf: self.suggestionsWithComment(relatedTo: lastFeedback!, with: restaurant))
                            return $0.say(oneOf: self.confirmations).finish()
                        }], withTag: RandomizerTagsProposal)
            }
        } else {
            script.say(oneOf: self.suggestions(with: restaurant))
        }
        return script.finish()
    }

    func processSearchError(error: NSError, withScript script: Script) -> (Script) {
        if error is LocationServiceAuthorizationStatusDeniedError {
            script.say(oneOf: {
                $0.words(["Ooops... I can't find out my current location.\n\nI need to know where I am.\n\nPlease turn Location Services on at Settings > Privacy > Location Services."]
                        , withCustomData: FoodHeroParameters(semanticId: "FH:BecauseUserDeniedAccessToLocationServices", state: "afterCantAccessLocationService"))
            })
        } else if error is LocationServiceAuthorizationStatusRestrictedError {
            script.say(oneOf: {
                $0.words(["I’m terribly sorry but there is a problem. I can’t access Location Services. I need access to Location Services in order that I know where I am."]
                        , withCustomData: FoodHeroParameters(semanticId: "FH:BecauseUserIsNotAllowedToUseLocationServices", state: "afterCantAccessLocationService"))
            })
        } else if error is NoRestaurantsFoundError || error is SearchError {
            script.say(oneOf: {
                $0.words(["That’s weird. I can’t find any restaurants right now."]
                        , withCustomData: FoodHeroParameters(semanticId: "FH:NoRestaurantsFound", state: "noRestaurantWasFound"))
            })
        } else {
            assert(false, "no error-handler for class \(reflect(error).summary) found")
        }
        return script.finish()
    }

    func searchRestaurant(response: TalkerUtterance, script: Script) -> (Script) {

        let bestRestaurant = _search.findBest(self._conversation)

        bestRestaurant.subscribeError {
            (error: NSError!) in
            self.processSearchError(error!, withScript: script)
            return
        }

        bestRestaurant.subscribeNext {
            (obj) in
            self.processSearchResult(obj, withScript: script)
            return
        }
        return script
    }
}
