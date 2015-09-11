//
// Created by Jorg on 11/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class UserFeedbackScript: Script {
    let _conversation: Conversation
    let _schedulerFactory: ISchedulerFactory

    public init(context: TalkerContext,
                conversation: Conversation,
                schedulerFactory: ISchedulerFactory) {
        _conversation = conversation
        _schedulerFactory = schedulerFactory

        super.init(talkerContext: context)


        say(oneOf: FHUtterances.askForProductFeedback)
        waitUserResponse(andContinueWith: {
            (parameter, futureScript) in
            if( parameter.hasSemanticId("U:ProductFeedback=Yes")){
                return futureScript.define{
                    return $0.say(oneOf:FHUtterances.thankForProductFeedback)
                }
            }
            else{
                return futureScript.defineEmpty()
            }


        }, catch: {
            self.catchError($0, errorScript: $1, andContinueWith: {
                (parameter, futureScript) in
                return futureScript.defineEmpty()
            })
        })

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
                assert(count(currentState) > 0, "UserIntentUnclearError.state was nil or empty")
                return FHUtterances.didNotUnderstandAndAsksForRepetition($0, state: currentState, expectedUserUtterances: expectedUserUtterances)
            })
            return errorScript.waitUserResponse(andContinueWith: continuation, catch: {
                self.catchError($0, errorScript: $1, andContinueWith: continuation)
            })
        } else {
            assert(false, "unexpected error of type \(reflect(error).summary)")
            return errorScript
        }
    }
}
