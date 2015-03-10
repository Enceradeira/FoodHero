//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "Restaurant.h"
#import "ConversationSource.h"


@interface USuggestionFeedback : ConversationToken

@property(nonatomic, readonly) Restaurant *restaurant;

- (instancetype)initWithRestaurant:(Restaurant *)restaurant text:(NSString *)text type:(NSString*)type;

@end