//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "Restaurant.h"

@interface FHSuggestionBase : ConversationToken
@property(nonatomic, readonly) Restaurant *restaurant;

- (instancetype)initWithRestaurant:(Restaurant *)restaurant;
@end