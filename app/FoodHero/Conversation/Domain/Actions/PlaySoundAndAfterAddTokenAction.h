//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "FHAction.h"
#import "PlaySoundAndAfterAddTokenActionDelegate.h"
#import "Sound.h"


@interface PlaySoundAndAfterAddTokenAction : NSObject <FHAction>

- (void)setDelegate:(id <PlaySoundAndAfterAddTokenActionDelegate>)delegate;

+ (id <ConversationAction>)create:(ConversationToken *)token sound:(Sound *)sound;
@end