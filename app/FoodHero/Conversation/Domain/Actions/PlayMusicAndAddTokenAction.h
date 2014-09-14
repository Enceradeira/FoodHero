//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "FHAction.h"

@class FHOpeningQuestion;


@interface PlayMusicAndAddTokenAction : NSObject <FHAction>

+ (id <ConversationAction>)create:(ConversationToken *)token;
@end