//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "FHSuggestionBase.h"

@class Restaurant;


@interface FHSuggestionWithConfirmationIfInNewPreferredRangeCheaper : FHSuggestionBase
+ (ConversationToken *)create:(Restaurant *)restaurant;
@end