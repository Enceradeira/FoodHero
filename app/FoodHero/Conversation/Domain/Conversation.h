//
//  Conversation.h
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "Statement.h"
#import "RestaurantSearchService.h"
#import "ActionFeedbackTarget.h"

@class ConversationToken;

@interface Conversation : NSObject<ActionFeedbackTarget>

- (Statement *)getStatement:(NSUInteger)index;

- (NSUInteger)getStatementCount;

- (RACSignal *)statementIndexes;
@end
