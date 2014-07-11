//
//  Conversation.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "Conversation.h"
#import "Personas.h"
#import "DesignByContractException.h"
#import "RestaurantSearch.h"


@interface Conversation ()
@property(nonatomic) NSMutableArray *statements;
@end

@implementation Conversation {
    RestaurantSearch *_restaurantSearch;
}

- (id)initWithDependencies:(RestaurantSearch *)restaurantSearch {
    self = [super init];
    if (self != nil) {
        _restaurantSearch = restaurantSearch;
        _statements = [NSMutableArray new];

        [_statements addObject:[[Statement alloc] initWithText:@"Hi there. What kind of food would you like to eat?" semanticId:@"Greeting&OpeningQuestion" persona:Personas.foodHero]];
    }
    return self;
}

- (Statement *)getStatement:(NSUInteger)index {
    if (index > [_statements count] - 1) {
        @throw [[DesignByContractException alloc] initWithReason:[NSString stringWithFormat:@"no conversation exists at index %ld", (long) index]];
    }

    return _statements[index];
}

- (void)addStatement:(NSString *)statement {
    NSMutableArray *statementProxy = [self mutableArrayValueForKey:@"statements"]; // In order that KVC-Events are fired

    [statementProxy addObject:[[Statement alloc] initWithText:statement semanticId:[NSString stringWithFormat:@"UserAnswer:%@", statement] persona:Personas.user]];

    [[_restaurantSearch findBest] subscribeNext:^(id next){
        Restaurant *restaurant = next;
        NSString *nameAndPlace = [NSString stringWithFormat:@"%@, %@", restaurant.name, restaurant.vicinity];
        NSString *text = [[NSString alloc] initWithFormat:@"Maybe you like the '%@'?", nameAndPlace];

        [statementProxy addObject:[[Statement alloc] initWithText:text semanticId:[NSString stringWithFormat:@"Suggestion:%@", nameAndPlace] persona:Personas.foodHero]];
    }];
}

- (NSUInteger)getStatementCount {
    return _statements.count;
}

- (RACSignal *)statementIndexes {
    NSUInteger __block index = 0;
    return [RACObserve(self, self.statements) map:^(id next){
        return [NSNumber numberWithUnsignedInt:index++];
    }];
}

@end
