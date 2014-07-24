//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "Restaurant.h"
#import "FHSuggestionBase.h"

@interface FHSuggestionAsFollowUp : FHSuggestionBase
@property(nonatomic, readonly) Restaurant *restaurant;

+ (instancetype)create:(Restaurant *)restaurant;

@end