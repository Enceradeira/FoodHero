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
#import "ConversationSource.h"

@class ConversationParameters;

@interface Conversation : NSObject <ConversationSource>

- (instancetype)initWithInput:(RACSignal *)input;

- (Statement *)getStatement:(NSUInteger)index;

- (NSUInteger)getStatementCount;

- (RACSignal *)statementIndexes;

- (SearchProfile *)currentSearchPreference:(double)maxDistancePlaces currUserLocation:(CLLocation *)location;

- (NSArray *)suggestedRestaurants;

- (ConversationParameters *)lastUserResponse;
@end
