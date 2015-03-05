//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "FoodHero-Swift.h"

@interface UDidResolveProblemWithAccessLocationService : ConversationToken
+ (instancetype)create:(NSString *)text;

+ (TalkerUtterance *)createUtterance:(NSString *)text;
@end