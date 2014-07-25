//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "Restaurant.h"
#import "ConversationAction.h"
#import "ConversationSource.h"


@interface USuggestionFeedback : ConversationToken

@property(nonatomic, readonly) Restaurant *restaurant;

- (instancetype)initWithRestaurant:(Restaurant *)restaurant parameter:(NSString *)parameter;

- (id <ConversationAction>)createAction:(id <ConversationSource>)source;
@end