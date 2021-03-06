//
// Created by Jorg on 11/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class ProductFeedbackScript: Script {
    let _conversation: Conversation
    let _schedulerFactory: ISchedulerFactory

    public init(context: TalkerContext,
                conversation: Conversation,
                schedulerFactory: ISchedulerFactory) {
        _conversation = conversation
        _schedulerFactory = schedulerFactory

        super.init(talkerContext: context)

        say(oneOf: FHUtterances.askForProductFeedback)
        waitUserResponse(andContinueWith: processProductFeedbackAnswerForParameter, `catch`: {
            self.catchError($0, errorScript: $1, andContinueWith: self.processProductFeedbackAnswerForParameter)
        })

    }

    func processProductFeedbackAnswerForParameter(parameter: ConversationParameters, futureScript: FutureScript) -> FutureScript {
        let utteranceBeforeInterrupting = self._conversation.lastFoodHeroUtteranceProductFeedback()
        var utterance: (StringDefinition) -> (StringDefinition)
        if (parameter.hasSemanticId("U:ProductFeedback=Yes")) {
            utterance = FHUtterances.thankForProductFeedback
        } else {
            utterance = FHUtterances.regrestsUserNotGivingProductFeedback
        }
        return futureScript.define {
            return $0.say(oneOf: utterance)
            .say(oneOf: { $0.words([utteranceBeforeInterrupting.utterance], withCustomData: utteranceBeforeInterrupting.customData[0]) })
        }
    }

    func catchError(
            error: NSError,
            errorScript: Script,
            andContinueWith continuation: ((ConversationParameters, FutureScript) -> (FutureScript))) -> Script {

        if error is UserIntentUnclearError {
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
}
