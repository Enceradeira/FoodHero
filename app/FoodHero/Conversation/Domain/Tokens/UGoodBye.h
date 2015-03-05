//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "FoodHero-Swift.h"


@interface UGoodBye : ConversationToken
+ (ConversationToken *)create:(NSString *)text;

+ (TalkerUtterance *)createUtterance:(NSString *)text;
@end