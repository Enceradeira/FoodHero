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

    public init(context context: TalkerContext,
                conversation: Conversation,
                search: RestaurantSearch,
                locationService: LocationService,
                schedulerFactory: ISchedulerFactory) {
        _conversation = conversation
        _search = search
        _locationService = locationService
        _schedulerFactory = schedulerFactory

        super.init(context: context)

        say(oneOf: FHUtterances.greetings)
        sayOpeningQuestionWaitResponseAndSearchRepeatably(self)
    }

    func sayOpeningQuestionWaitResponseAndSearchRepeatably(script: Script) -> (Script) {
        let openingQuestion = FHUtterances.openingQuestions
        script.say(oneOf: openingQuestion)
        return self.waitResponseAndSearchRepeatably(script, forQuestion: openingQuestion)
    }

    func confirmRestartSayOpeningQuestionAndSearchRepeatably(futureScript: FutureScript) -> FutureScript {
        return futureScript.define {
            $0.say(oneOf: FHUtterances.confirmationRestart)
            return self.sayOpeningQuestionWaitResponseAndSearchRepeatably($0)
        }
    }

    func catchError(
            error: NSError,
            errorScript: Script,
            lastQuestion: (StringDefinition) -> (StringDefinition),
            andContinueWith continuation: ((ConversationParameters, FutureScript) -> (FutureScript))) -> Script {

        if error is NetworkError {
            errorScript.say(oneOf: FHUtterances.hasNetworkErrorAndAsksIfShouldTryAgain)
            return errorScript.waitUserResponse(andContinueWith: {
                parameter, futureScript in
                return futureScript.define {
                    $0.say(oneOf: FHUtterances.beforeRepeatingUtteranceAfterError)
                    $0.say(oneOf: lastQuestion)
                    return self.waitUserResponseAndHandleErrors($0, forQuestion: lastQuestion, andContinueWith: continuation)
                }
                return futureScript
            }, catch: {
                self.catchError($0, errorScript: $1, lastQuestion: lastQuestion, andContinueWith: continuation)
            })
        } else {
            assert(false, "unexpected error of type \(reflect(error).summary)")
        }
    }

    public func waitUserResponseAndHandleErrors(
            script: Script,
            forQuestion lastQuestion: (StringDefinition) -> (StringDefinition),
            andContinueWith continuation: ((ConversationParameters, FutureScript) -> (FutureScript))) -> Script {
        return script.waitUserResponse(andContinueWith: continuation, catch: {
            self.catchError($0, errorScript: $1, lastQuestion: lastQuestion, andContinueWith: continuation)
        })
    }

    func waitResponseAndSearchRepeatably(script: Script, forQuestion lastQuestion: (StringDefinition) -> (StringDefinition)) -> (Script) {
        return waitUserResponseAndHandleErrors(script, forQuestion: lastQuestion) {
            if $0.hasSemanticId("U:WantsToStartAgain") {
                return self.confirmRestartSayOpeningQuestionAndSearchRepeatably($1)
            } else if !$0.hasSemanticId("U:SuggestionFeedback=Like") {
                return self.searchAndWaitResponseAndSearchRepeatably($1, forQuestion: lastQuestion)
            } else {
                return $1.define {
                    $0.say(oneOf: FHUtterances.commentChoices)
                    return self.askWhatToDoNext($0)
                }
            }
        }
    }

    func searchAndWaitResponseAndSearchRepeatably(futureScript: FutureScript, forQuestion lastQuestion: (StringDefinition) -> (StringDefinition)) -> (FutureScript) {

        let bestRestaurant = _search.findBest(self._conversation).deliverOn(_schedulerFactory.mainThreadScheduler())

        bestRestaurant.subscribeError {
            (error: NSError!) in
            futureScript.define {
                return self.processSearchError(error!, withScript: $0)
            }
            return
        }

        bestRestaurant.subscribeNext {
            (obj) in
            futureScript.define {
                return self.processSearchResult(obj, withScript: $0)
            }
            return
        }
        return futureScript
    }

    func askWhatToDoNext(script: Script) -> (Script) {
        let question = FHUtterances.whatToDoNext
        script.say(oneOf: question)
        return waitResponseForWhatToDoNext(script, forQuestion: question)
    }

    func waitResponseForWhatToDoNext(script: Script, forQuestion lastQuestion: (StringDefinition) -> (StringDefinition)) -> (Script) {
        return waitUserResponseAndHandleErrors(script, forQuestion: lastQuestion) {
            if $0.hasSemanticId("U:GoodBye") {
                return $1.define {
                    let question = FHUtterances.goodbyes
                    $0.say(oneOf: question)
                    return self.waitUserResponseAndHandleErrors($0, forQuestion: question) {
                        return $1.define {
                            return self.sayOpeningQuestionWaitResponseAndSearchRepeatably($0)
                        }
                    }
                }
            } else {
                return $1.define {
                    return self.sayOpeningQuestionWaitResponseAndSearchRepeatably($0)
                }
            }
        }
    }

    func userResponseIs(semanticId: String) -> () -> Bool {
        return {
            let lastResponse = self._conversation.lastUserResponse()
            return lastResponse != nil && lastResponse!.hasSemanticId(semanticId)
        }
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
                script.say(oneOf: FHUtterances.warningsIfNotInPreferredRangeTooCheap)
                let lastUtterance = FHUtterances.suggestionsAfterWarning(with: restaurant)
                script.say(oneOf: lastUtterance)
                return self.waitResponseAndSearchRepeatably(script, forQuestion: lastUtterance)
            } else if priceRange.max < restaurant.priceLevel
                    && (lastSuggestionWarning == nil || !lastSuggestionWarning.hasSemanticId("FH:WarningIfNotInPreferredRangeTooExpensive")) {
                script.say(oneOf: FHUtterances.warningsIfNotInPreferredRangeTooExpensive)
                let lastUtterance = FHUtterances.suggestionsAfterWarning(with: restaurant)
                script.say(oneOf: lastUtterance)
                return self.waitResponseAndSearchRepeatably(script, forQuestion: lastUtterance)
            } else if searchPreference.distanceRange.max < restaurant.location.distanceFromLocation(self._locationService.lastKnownLocation())
                    && (lastSuggestionWarning == nil || !lastSuggestionWarning.hasSemanticId("FH:WarningIfNotInPreferredRangeTooFarAway")) {
                script.say(oneOf: FHUtterances.warningsIfNotInPreferredRangeTooFarAway)
                let lastUtterance = FHUtterances.suggestionsAfterWarning(with: restaurant)
                script.say(oneOf: lastUtterance)
                return self.waitResponseAndSearchRepeatably(script, forQuestion: lastUtterance)
            } else {
                let defaultUtterance = FHUtterances.suggestions(with: restaurant)
                script.chooseOne(from: [
                        {
                            return $0.define {
                                $0.say(oneOf: defaultUtterance)
                            }
                        },
                        {
                            return $0.define {
                                $0.say(oneOf: FHUtterances.suggestionsAsFollowUp(with: restaurant))
                                if lastFeedback!.hasSemanticId("U:SuggestionFeedback=tooCheap") {
                                    return $0.saySometimes(oneOf: FHUtterances.confirmationsIfInNewPreferredRangeMoreExpensive, withTag: RandomizerConstants.confirmationIfInNewPreferredRange())
                                } else if lastFeedback!.hasSemanticId("U:SuggestionFeedback=tooExpensive") {
                                    return $0.saySometimes(oneOf: FHUtterances.confirmationIfInNewPreferredRangeCheaper, withTag: RandomizerConstants.confirmationIfInNewPreferredRange())
                                } else if lastFeedback!.hasSemanticId("U:SuggestionFeedback=tooFarAway") {
                                    return $0.saySometimes(oneOf: FHUtterances.confirmationIfInNewPreferredRangeCloser, withTag: RandomizerConstants.confirmationIfInNewPreferredRange())
                                }
                                return $0
                            }

                        },
                        {
                            return $0.define {
                                $0.say(oneOf: FHUtterances.suggestionsWithComment(relatedTo: lastFeedback!, with: restaurant))
                                return $0.say(oneOf: FHUtterances.confirmations)
                            }
                        }], withTag: RandomizerConstants.proposal())
                return self.waitResponseAndSearchRepeatably(script, forQuestion: defaultUtterance)
            }
        } else {
            let lastUtterance = FHUtterances.suggestions(with: restaurant)
            script.say(oneOf: lastUtterance)
            return self.waitResponseAndSearchRepeatably(script, forQuestion: lastUtterance)
        }
    }

    func processSearchError(error: NSError, withScript script: Script) -> (Script) {
        if error is LocationServiceAuthorizationStatusDeniedError {
            let lastQuestion = FHUtterances.cantAccessLocationServiceBecauseUserDeniedAccessToLocationServices
            script.say(oneOf: lastQuestion)
            return self.waitResponseAndSearchRepeatably(script, forQuestion: lastQuestion)
        } else if error is LocationServiceAuthorizationStatusRestrictedError {
            let lastQuestion = FHUtterances.cantAccessLocationServiceBecauseUserIsNotAllowedToUseLocationServices
            script.say(oneOf: lastQuestion)
            return self.waitResponseAndSearchRepeatably(script, forQuestion: lastQuestion)
        } else if error is NoRestaurantsFoundError || error is SearchError {
            let lastQuestion = FHUtterances.noRestaurantsFound
            script.say(oneOf: lastQuestion)
            self.waitUserResponseAndHandleErrors(script, forQuestion: lastQuestion) {
                if $0.hasSemanticId("U:WantsToAbort") {
                    return $1.define {
                        let whatToDoNextAfterFailure = FHUtterances.whatToDoNextAfterFailure
                        $0.say(oneOf: whatToDoNextAfterFailure)
                        return self.waitResponseForWhatToDoNext($0, forQuestion: whatToDoNextAfterFailure)
                    }
                } else if $0.hasSemanticId("U:TryAgainNow") {
                    return self.searchAndWaitResponseAndSearchRepeatably($1, forQuestion: lastQuestion)
                } else if $0.hasSemanticId("U:WantsToStartAgain") {
                    return self.confirmRestartSayOpeningQuestionAndSearchRepeatably($1)
                } else {
                    assert(false, "response \($0.semanticIdInclParameters) not handled")
                }
            }
            return self.waitResponseAndSearchRepeatably(script, forQuestion: lastQuestion)
        } else {
            assert(false, "no error-handler for class \(reflect(error).summary) found")
        }

    }
}
