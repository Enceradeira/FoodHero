//
// Created by Jorg on 09/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class ConversationScript: Script {
    let _conversation: Conversation
    let _search: RestaurantSearch
    let _locationService: LocationService
    let _schedulerFactory: ISchedulerFactory
    var _processSearchRequests = false

    public init(context: TalkerContext,
                conversation: Conversation,
                controlInput: RACSignal,
                search: RestaurantSearch,
                locationService: LocationService,
                schedulerFactory: ISchedulerFactory) {
        _conversation = conversation
        _search = search
        _locationService = locationService
        _schedulerFactory = schedulerFactory

        super.init(talkerContext: context)

        controlInput.subscribeNext {
            self.processControlInput($0)
        }
    }

    public func startProcessingSearchRequests() {
        _processSearchRequests = true
    }

    // The time before FoodHero informs user that he's busy/delayed
    public static var searchTimeout: Double = 15

    private func sayGreetingAndSearchRepeatably(script: Script) -> Script {
        script.say(oneOf: FHUtterances.greetings)
        script.continueWith(continuation: {
            self.searchAndWaitResponseAndSearchRepeatably()
            return $0.defineEmpty()
        })

        return script
    }

    private func sayOpeningQuestionWaitResponseAndSearchRepeatably(script: Script) -> (Script) {
        let openingQuestion = FHUtterances.openingQuestions
        script.say(oneOf: openingQuestion)
        return self.waitResponseAndSearchRepeatably(script)
    }

    private func askForKindOfFoodWaitResponseAndSearchRepeatably(script: Script) -> (Script) {
        let question = FHUtterances.askForKindOfFood
        script.say(oneOf: question)
        return self.waitResponseAndSearchRepeatably(script)
    }

    private func askForOccasionWaitResponseAndSearchRepeatably(script: Script) -> (Script) {
        let currentOccasion = self._conversation.currentOccasion()
        let question = FHUtterances.askForOccasion(currentOccasion)
        script.say(oneOf: question)
        return self.waitResponseAndSearchRepeatably(script)
    }

    private func confirmRestartSayOpeningQuestionAndSearchRepeatably(futureScript: FutureScript) -> FutureScript {
        return futureScript.define {
            $0.say(oneOf: FHUtterances.confirmationRestart)
            return self.sayOpeningQuestionWaitResponseAndSearchRepeatably($0)
        }
    }

    private func catchError(
            error: NSError,
            errorScript: Script,
            andContinueWith continuation: ((ConversationParameters, FutureScript) -> (FutureScript))) -> Script {

        if error is NetworkError {
            errorScript.say(oneOf: FHUtterances.hasNetworkErrorAndAsksIfShouldTryAgain)
            return errorScript.waitUserResponse(andContinueWith: {
                parameter, futureScript in
                return futureScript.define {
                    $0.say(oneOf: FHUtterances.beforeRepeatingUtteranceAfterError)
                    let lastUtteranceBeforeError = self._conversation.lastFoodHeroUtteranceBeforeNetworkError()
                    $0.say(oneOf: { $0.words([lastUtteranceBeforeError.utterance], withCustomData: lastUtteranceBeforeError.customData[0]) })
                    return self.waitUserResponseAndHandleErrors($0, andContinueWith: continuation)
                }
            }, `catch`: {
                self.catchError($0, errorScript: $1, andContinueWith: continuation)
            })
        } else if error is UserIntentUnclearError {
            errorScript.say(oneOf: {
                let intentUnclearError = error as! UserIntentUnclearError
                let currentState = intentUnclearError.state
                let expectedUserUtterances = intentUnclearError.expectedUserUtterances
                assert(currentState.characters.count > 0, "UserIntentUnclearError.state was nil or empty")
                return FHUtterances.didNotUnderstandAndAsksForRepetition($0, state: currentState, expectedUserUtterances: expectedUserUtterances)
            })
            return errorScript.waitUserResponse(andContinueWith: continuation, `catch`: {
                self.catchError($0, errorScript: $1, andContinueWith: continuation)
            })
        } else {
            assert(false, "unexpected error of type \(Mirror(reflecting: error).description)")
            return errorScript
        }
    }

    public func waitUserResponseAndHandleErrors(
            script: Script,
            andContinueWith continuation: ((ConversationParameters, FutureScript) -> (FutureScript))) -> Script {
        return script.waitUserResponse(andContinueWith: {
            (parameter, futureScript) in
            // Handle everything here that is accepted in 'All States'
            if parameter.hasSemanticId("U:CuisinePreference") || parameter.hasSemanticId("U:OccasionPreference") {
                self.searchAndWaitResponseAndSearchRepeatably()
                return futureScript
            } else {
                return continuation(parameter, futureScript)
            }
        }, `catch`: {
            self.catchError($0, errorScript: $1, andContinueWith: continuation)
        })
    }

    private func waitResponseAndSearchRepeatably(script: Script) -> (Script) {
        return waitUserResponseAndHandleErrors(script) {
            if $0.hasSemanticId("U:WantsToStartAgain") {
                return self.confirmRestartSayOpeningQuestionAndSearchRepeatably($1)
            } else if $0.hasSemanticId("U:DislikesKindOfFood") {
                return $1.define {
                    return self.askForKindOfFoodWaitResponseAndSearchRepeatably($0)
                }
            } else if $0.hasSemanticId("U:DislikesOccasion") {
                return $1.define {
                    return self.askForOccasionWaitResponseAndSearchRepeatably($0)
                }
            } else if $0.hasSemanticId("U:WantsToAbort") {
                return self.askWhatToDoNextAfterFailure($1)
            } else if $0.hasSemanticId("U:LocationRequest") {
                let restaurants = self._conversation.suggestedRestaurantsInCurrentSearch() as! [Restaurant]
                let lastRestaurant: Restaurant = restaurants.last!
                let occasion = self._conversation.currentOccasion()
                return $1.define {
                    $0.say(oneOf: { FHUtterances.tellRestaurantLocation($0, ofRestaurant: lastRestaurant, currentOccasion: occasion) })
                    return self.waitResponseAndSearchRepeatably($0)
                }
            } else if !$0.hasSemanticId("U:SuggestionFeedback=Like") {
                self.searchAndWaitResponseAndSearchRepeatably()
                return $1
            } else {
                if $0.hasSemanticId("U:SuggestionFeedback=LikeWithLocationRequest") {
                    let restaurants = self._conversation.suggestedRestaurantsInCurrentSearch() as! [Restaurant]
                    let lastRestaurant: Restaurant = restaurants.last!
                    return $1.define {
                        $0.say(oneOf: { FHUtterances.commentChoiceAndTellUserLocation($0, ofRestaurant: lastRestaurant) })
                        return self.askWhatToDoNext($0)
                    }
                } else {
                    // "U:SuggestionFeedback=Like"
                    return $1.define {
                        $0.say(oneOf: FHUtterances.commentChoices)
                        return self.askWhatToDoNext($0)
                    }
                }
            }
        }
    }

    private func searchAndWaitResponseAndSearchRepeatably() {
        var searchHasEnded = false
        if !_processSearchRequests {
            return
        }

        let bestRestaurant = _search.findBest(self._conversation).deliverOn(_schedulerFactory.mainThreadScheduler()).take(1)

        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(ConversationScript.searchTimeout * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            if searchHasEnded {
                return;
            }
            self._conversation.sendControlInput(IsVeryBusyAtTheMomentInterruption())
        }

        bestRestaurant.subscribeError {
            (error: NSError!) in
            searchHasEnded = true
            self._conversation.sendControlInput(SearchErrorControlInput(error: error))
            return
        }

        bestRestaurant.subscribeNext {
            (obj) in
            searchHasEnded = true
            self._conversation.sendControlInput(SearchResultControlInput(result: obj as! RestaurantSearchResult))
            return
        }
    }

    private func askWhatToDoNext(script: Script) -> (Script) {
        let question = FHUtterances.whatToDoNext
        script.say(oneOf: question)
        return waitResponseForWhatToDoNext(script)
    }

    private func askWhatToDoNextAfterFailure(script: FutureScript) -> (FutureScript) {
        return script.define {
            let whatToDoNextAfterFailure = FHUtterances.whatToDoNextAfterFailure
            $0.say(oneOf: whatToDoNextAfterFailure)
            return self.waitResponseForWhatToDoNext($0)
        }
    }

    private func sayGoodbyeAndWaitResponse(script: Script) -> (Script) {
        let question = FHUtterances.goodbyes
        script.say(oneOf: question)
        return waitUserHelloAndHandleErrors(script)
    }

    public func waitUserHelloAndHandleErrors(script: Script) -> Script {
        return waitUserResponseAndHandleErrors(script) {
            if $0.hasSemanticId("U:Hello") {
                return $1.define {
                    return self.sayGreetingAndSearchRepeatably($0)
                }
            } else {
                return $1.define {
                    return self.waitUserHelloAndHandleErrors($0)
                }
            }
        }
    }

    private func waitResponseForWhatToDoNext(script: Script) -> (Script) {
        return waitUserResponseAndHandleErrors(script) {
            if $0.hasSemanticId("U:WantsToStopConversation") {
                return $1.define {
                    return self.sayGoodbyeAndWaitResponse($0)
                }
            } else {
                return $1.define {
                    return self.sayOpeningQuestionWaitResponseAndSearchRepeatably($0)
                }
            }
        }
    }

    private func userResponseIs(semanticId: String) -> () -> Bool {
        return {
            let lastResponse = self._conversation.lastUserResponse()
            return lastResponse != nil && lastResponse!.hasSemanticId(semanticId)
        }
    }

    private func sayWarning(script: Script, semanticID: String, sayings: (StringDefinition, Restaurant, String) -> (StringDefinition), lastSuggestionWarning: ConversationParameters?, restaurant: Restaurant, currentOccasion: String) -> Script {

        var lastUtterance: (StringDefinition) -> (StringDefinition)
        if (lastSuggestionWarning == nil || !lastSuggestionWarning!.hasSemanticId(semanticID)) {
            lastUtterance = {
                sayings($0, restaurant, currentOccasion)
            }
        } else {
            script.say(oneOf: FHUtterances.suggestions(with: restaurant, currentOccasion: currentOccasion))
            lastUtterance = FHUtterances.followUpQuestion(currentOccasion)
        }
        script.say(oneOf: lastUtterance)
        return self.waitResponseAndSearchRepeatably(script)
    }

    private func processSearchResult(result: AnyObject, withScript script: Script) -> (Script) {
        let searchResult = result as! RestaurantSearchResult
        let restaurant = searchResult.restaurant
        let searchParams = searchResult.searchParams

        let negativesFeedback = self._conversation.negativeUserFeedback()!
        let lastFeedback = (negativesFeedback.count > 0 ? negativesFeedback.last : nil) as! USuggestionFeedbackParameters?
        let lastSuggestionWarning = self._conversation.lastSuggestionWarning() as ConversationParameters?
        let currentOccasion = _conversation.currentOccasion()!
        let isFirstSuggestion = (self._conversation.suggestedRestaurantsInCurrentSearch() as! [Restaurant]).isEmpty && currentOccasion != ""
        let defaultUtterance = FHUtterances.suggestions(with: restaurant, currentOccasion: currentOccasion)
        let defaultQuestion = FHUtterances.followUpQuestion(currentOccasion)

        if isFirstSuggestion {
            script.say(oneOf: FHUtterances.suggestions(with: restaurant, currentOccasion: currentOccasion))
            let lastUtterance = FHUtterances.firstQuestion(with: searchParams.occasion)
            script.say(oneOf: lastUtterance)
            return self.waitResponseAndSearchRepeatably(script)
        } else if (!_conversation.wasChatty) {
            if lastFeedback != nil && lastFeedback?.restaurant != nil {
                let maxDistance = _search.getMaxDistanceOfPlaces()
                let searchPreference = self._conversation.currentSearchPreference(maxDistance, searchLocation: _search.lastSearchLocation())
                let priceRange = searchPreference.priceRange
                if priceRange.min > restaurant.priceLevel {
                    return sayWarning(script,
                            semanticID: "FH:SuggestionIfNotInPreferredRangeTooCheap",
                            sayings: FHUtterances.suggestionsIfNotInPreferredRangeTooCheap,
                            lastSuggestionWarning: lastSuggestionWarning, restaurant: restaurant, currentOccasion: currentOccasion);
                } else if priceRange.max < restaurant.priceLevel {
                    return sayWarning(script,
                            semanticID: "FH:SuggestionIfNotInPreferredRangeTooExpensive",
                            sayings: FHUtterances.suggestionsIfNotInPreferredRangeTooExpensive,
                            lastSuggestionWarning: lastSuggestionWarning, restaurant: restaurant, currentOccasion: currentOccasion);
                } else if searchPreference.distanceRange != nil && searchPreference.distanceRange.max < (restaurant.location.distanceFromLocation(_search.lastSearchLocation()) / maxDistance) {
                    return sayWarning(script,
                            semanticID: "FH:SuggestionIfNotInPreferredRangeTooFarAway",
                            sayings: FHUtterances.suggestionsIfNotInPreferredRangeTooFarAway,
                            lastSuggestionWarning: lastSuggestionWarning, restaurant: restaurant, currentOccasion: currentOccasion);
                } else {

                    script.chooseOne(from: [
                            {
                                return $0.define {
                                    $0.say(oneOf: defaultUtterance)
                                    return $0.say(oneOf: defaultQuestion)
                                }
                            },
                            {
                                return $0.define {
                                    $0.say(oneOf: FHUtterances.suggestionsAsFollowUp(with: restaurant, lastRestaurant: lastFeedback!.restaurant, currentOccasion: currentOccasion))
                                    return $0
                                }

                            },
                            {
                                return $0.define {
                                    return $0.say(oneOf: FHUtterances.confirmationIfInNewPreferedRange(relatedTo: lastFeedback!, with: restaurant, currentOccasion: currentOccasion))
                                }
                            },
                            {
                                return $0.define {
                                    return $0.say(oneOf: FHUtterances.simpleSuggestion(with: restaurant, currentOccasion: currentOccasion))
                                }
                            }
                    ], withTag: RandomizerConstants.proposal())
                    return self.waitResponseAndSearchRepeatably(script)
                }
            } else {
                /* it's not the first time but user has not yet commented a restaurant (because he disliked the
                    cuisine (U:DislikesKindOfFood)) */
                script.say(oneOf: FHUtterances.suggestions(with: restaurant, currentOccasion: currentOccasion))
                let question = FHUtterances.followUpQuestion(currentOccasion)
                script.say(oneOf: question)
                return self.waitResponseAndSearchRepeatably(script)
            }
        } else {
            script.say(oneOf: FHUtterances.simpleSuggestion(with: restaurant, currentOccasion: currentOccasion))
            return self.waitResponseAndSearchRepeatably(script)
        }
    }

    private func processSearchError(error: NSError, withScript script: Script) -> (Script) {
        if error is LocationServiceAuthorizationStatusDeniedError {
            let lastQuestion = FHUtterances.cantAccessLocationServiceBecauseUserDeniedAccessToLocationServices
            script.say(oneOf: lastQuestion)
            return self.waitResponseAndSearchRepeatably(script)
        } else if error is LocationServiceAuthorizationStatusRestrictedError {
            let lastQuestion = FHUtterances.cantAccessLocationServiceBecauseUserIsNotAllowedToUseLocationServices
            script.say(oneOf: lastQuestion)
            return self.waitResponseAndSearchRepeatably(script)
        } else if error is NoRestaurantsFoundError || error is SearchError {
            let label = String(error.dynamicType)
            logEventWithCategory(GAICategories.negativeExperience(), action: GAIActions.negativeExperienceError(), label: label, value: 0)

            let lastQuestion = FHUtterances.noRestaurantsFound
            script.say(oneOf: lastQuestion)
            self.waitUserResponseAndHandleErrors(script) {
                if $0.hasSemanticId("U:WantsToAbort") {
                    return self.askWhatToDoNextAfterFailure($1)
                } else if $0.hasSemanticId("U:TryAgainNow") {
                    return self.confirmRestartSayOpeningQuestionAndSearchRepeatably($1)
                } else if $0.hasSemanticId("U:WantsToStartAgain") {
                    return self.confirmRestartSayOpeningQuestionAndSearchRepeatably($1)
                } else {
                    assert(false, "response \($0.semanticIdInclParameters) not handled")
                    return $1
                }
            }

            return self.waitResponseAndSearchRepeatably(script)
        } else {
            assert(false, "no error-handler for class \(Mirror(reflecting: error).description) found")
            return script
        }

    }

    private func processControlInput(input: Any) {
        if input is RequestProductFeedbackInterruption {
            self.interrupt(with: ProductFeedbackScript(context: context, conversation: _conversation, schedulerFactory: _schedulerFactory))
        } else if input is IsVeryBusyAtTheMomentInterruption {
            self.interrupt(with: Script(talkerContext: context).say(oneOf: FHUtterances.isVeryBusyAtTheMoment))
        } else if let searchError = input as? SearchErrorControlInput {
            let errorScript = Script(talkerContext: context)
            self.processSearchError(searchError.error, withScript: errorScript)
            self.interrupt(with: errorScript)
        } else if let searchResult = input as? SearchResultControlInput {
            let resultScript = Script(talkerContext: context)
            self.processSearchResult(searchResult.result, withScript: resultScript)
            self.interrupt(with: resultScript)
        } else if let _ = input as? SayGreetingControlInput {
            self.interrupt(with: Script(talkerContext: context).say(oneOf: FHUtterances.greetings))
        } else if let _ = input as? StartSearchControlInput {
            self.searchAndWaitResponseAndSearchRepeatably()
        } else {
            assert(false, "unexpected control input of type \(Mirror(reflecting: input).description)")
        }
    }

    private func logEventWithCategory(category: String, action: String, label: String, value: Float) {
        if _processSearchRequests {
            // only send events when conversation is not beeing restored
            GAIService.logEventWithCategory(category, action: action, label: label, value: value)
        }
    }
}
