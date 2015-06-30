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
#import "ApplicationAssembly.h"

@class ConversationParameters;

@interface Conversation : NSObject <ConversationSource>

@property(nonatomic, readonly) NSString *id;

- (instancetype)initWithInput:(RACSignal *)input assembly:(id <ApplicationAssembly>)assembly;

- (void)start;

- (Statement *)getStatement:(NSUInteger)index;

- (NSUInteger)getStatementCount;

- (RACSignal *)statementIndexes;

- (SearchProfile *)currentSearchPreference:(double)maxDistancePlaces searchLocation:(CLLocation *)location;

- (NSString *)currentOccasion;

- (NSArray *)suggestedRestaurantsInCurrentSearch;

- (ConversationParameters *)lastUserResponse;

- (Statement *)lastRawSuggestion;
@end
