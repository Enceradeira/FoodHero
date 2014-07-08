//
//  Conversation.h
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Statement.h"
#import "RestaurantSearch.h"

@interface Conversation : NSObject

- (id)initWithDependencies:(NSObject<RestaurantSearch> *)restaurantSearch;

- (Statement *)getStatement:(NSUInteger)index;

- (void)addStatement:(NSString *)statement;

- (NSUInteger)getStatementCount;

@end
