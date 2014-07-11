//
//  Conversation.h
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Statement.h"
#import "RestaurantSearchService.h"

@class RACSignal;

@interface Conversation : NSObject

- (void)add:(NSString *)string;

- (Statement *)getStatement:(NSUInteger)index;

- (void)addStatement:(NSString *)statement;

- (NSUInteger)getStatementCount;

- (RACSignal *)statementIndexes;
@end
