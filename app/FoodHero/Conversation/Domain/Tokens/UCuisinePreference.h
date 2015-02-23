//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "FoodHero-Swift.h"

@interface UCuisinePreference : ConversationToken
+ (instancetype)create:(NSString *)parameter text:(NSString *)text;

+ (TalkerUtterance *)createUtterance:(NSString *)parameter text:(NSString *)text;
@end