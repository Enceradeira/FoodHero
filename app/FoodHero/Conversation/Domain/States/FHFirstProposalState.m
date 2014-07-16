//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHFirstProposalState.h"
#import "ConversationAction.h"
#import "ConversationToken.h"
#import "ConversationState.h"
#import "FHSuggestion.h"
#import "FHSuggestionState.h"
#import "DesignByContractException.h"


@implementation FHFirstProposalState {
}
- (id <ConversationAction>)consume:(ConversationToken *)token {
    return [[FHSuggestionState new] createAction];
}
@end