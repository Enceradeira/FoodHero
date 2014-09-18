//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "FHAction.h"
#import "PlaySoundDelegate.h"
#import "Sound.h"


@interface PlaySoundAndAfterAddTokenAction : NSObject <FHAction>
+ (id <ConversationAction>)create:(ConversationToken *)token sound:(Sound *)sound;
@end