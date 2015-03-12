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
        script.say(oneOf: FHUtterances.openingQuestions)
        return self.waitResponseAndSearchRepeatably(script)
    }

    func waitResponseAndSearchRepeatably(script: Script) -> (Script) {
        return script.waitUserResponse {
            if !$0.hasSemanticId("U:SuggestionFeedback=Like") {
                return self.searchAndWaitResponseAndSearchRepeatably($1)
            } else {
                return $1.define {
                    $0.say(oneOf: FHUtterances.commentChoices)
                    return self.askWhatToDoNext($0)
                }
            }
        }
    }

    func searchAndWaitResponseAndSearchRepeatably(futureScript: FutureScript) -> (FutureScript) {

        let bestRestaurant = _search.findBest(self._conversation).deliverOn(_schedulerFactory.mainThreadScheduler())

        bestRestaurant.subscribeError {
            (error: NSError!) in
            futureScript.define {
                self.processSearchError(error!, withScript: $0)
                return self.waitResponseAndSearchRepeatably($0)
            }
            return
        }

        bestRestaurant.subscribeNext {
            (obj) in
            futureScript.define {
                self.processSearchResult(obj, withScript: $0)
                return self.waitResponseAndSearchRepeatably($0)
            }
            return
        }
        return futureScript
    }

    func askWhatToDoNext(script: Script) -> (Script) {
        script.say(oneOf: FHUtterances.whatToDoNext)
        return waitResponseForWhatToDoNext(script)
    }

    func waitResponseForWhatToDoNext(script: Script) -> (Script) {
        return script.waitUserResponse {
            if $0.hasSemanticId("U:GoodBye") {
                return $1.define {
                    $0.say(oneOf: FHUtterances.goodbyes)
                    return $0.waitUserResponse {
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
                script.say(oneOf: FHUtterances.suggestionsAfterWarning(with: restaurant))
            } else if priceRange.max < restaurant.priceLevel
                    && (lastSuggestionWarning == nil || !lastSuggestionWarning.hasSemanticId("FH:WarningIfNotInPreferredRangeTooExpensive")) {
                script.say(oneOf: FHUtterances.warningsIfNotInPreferredRangeTooExpensive)
                script.say(oneOf: FHUtterances.suggestionsAfterWarning(with: restaurant))
            } else if searchPreference.distanceRange.max < restaurant.location.distanceFromLocation(self._locationService.lastKnownLocation())
                    && (lastSuggestionWarning == nil || !lastSuggestionWarning.hasSemanticId("FH:WarningIfNotInPreferredRangeTooFarAway")) {
                script.say(oneOf: FHUtterances.warningsIfNotInPreferredRangeTooFarAway)
                script.say(oneOf: FHUtterances.suggestionsAfterWarning(with: restaurant))
            } else {
                script.chooseOne(from: [
                        {
                            return $0.define {
                                $0.say(oneOf: FHUtterances.suggestions(with: restaurant))
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
            }
        } else {
            script.say(oneOf: FHUtterances.suggestions(with: restaurant))
        }
        return script
    }

    func processSearchError(error: NSError, withScript script: Script) -> (Script) {
        if error is LocationServiceAuthorizationStatusDeniedError {
            script.say(oneOf: FHUtterances.cantAccessLocationServiceBecauseUserDeniedAccessToLocationServices)
            return script
        } else if error is LocationServiceAuthorizationStatusRestrictedError {
            script.say(oneOf: FHUtterances.cantAccessLocationServiceBecauseUserIsNotAllowedToUseLocationServices)
            return script
        } else if error is NoRestaurantsFoundError || error is SearchError {
            script.say(oneOf: FHUtterances.noRestaurantsFound)
            script.waitUserResponse {
                if $0.hasSemanticId("U:WantsToAbort") {
                    return $1.define {
                        $0.say(oneOf: FHUtterances.whatToDoNextAfterFailure)
                        return self.waitResponseForWhatToDoNext($0)
                    }
                } else if $0.hasSemanticId("U:TryAgainNow") {
                    return self.searchAndWaitResponseAndSearchRepeatably($1)
                } else {
                    assert(false, "response \($0.semanticIdInclParameters) not handled")
                }
            }
            return script
        } else {
            assert(false, "no error-handler for class \(reflect(error).summary) found")
        }
    }
}
