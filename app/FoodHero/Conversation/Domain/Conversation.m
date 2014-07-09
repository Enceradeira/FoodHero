//
//  Conversation.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Conversation.h"
#import "Personas.h"
#import "DesignByContractException.h"
#import "RestaurantSearch.h"


@implementation Conversation {
    NSMutableArray *_statements;
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
    [_statements addObject:[[Statement alloc] initWithText:statement semanticId:[NSString stringWithFormat:@"UserAnswer:%@", statement] persona:Personas.user]];

    Restaurant *restaurant = [_restaurantSearch findBest];
    NSString *nameAndPlace = [NSString stringWithFormat:@"%@, %@", restaurant.name, restaurant.vicinity];
    NSString *text = [[NSString alloc] initWithFormat:@"Maybe you like the '%@'?", nameAndPlace];

    [_statements addObject:[[Statement alloc] initWithText:text semanticId:[NSString stringWithFormat:@"Suggestion:%@", nameAndPlace] persona:Personas.foodHero]];
}

- (NSUInteger)getStatementCount {
    return _statements.count;
}

@end
