//
//  Conversation.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import "Conversation.h"
#import "Personas.h"
#import "DesignByContractException.h"
#import "RestaurantSearch.h"
#import "LocationServiceAuthorizationStatusDeniedError.h"
#import "LocationServiceAuthorizationStatusRestrictedError.h"
#import "NoRestaurantsFoundError.h"


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

        [self addFoodHeroStatement:@"Hi there. What kind of food would you like to eat?" semanticId:@"FH:Greeting&FH:OpeningQuestion"];
    }
    return self;
}

- (void)addFoodHeroStatement:(NSString *)statement semanticId:(NSString *)semanticId {
    [self addStatement:statement semanticId:semanticId persona:Personas.foodHero];
}

- (void)addFoodUserStatement:(NSString *)statement semanticId:(NSString *)semanticId {
    [self addStatement:statement semanticId:semanticId persona:[Personas user]];
}

- (void)addStatement:(NSString *)text semanticId:(NSString *)semanticId persona:(Persona *)persona {
    NSMutableArray *statementProxy = [self mutableArrayValueForKey:@"statements"]; // In order that KVC-Events are fired
    [statementProxy addObject:[[Statement alloc] initWithText:text semanticId:semanticId persona:persona]];
}

- (Statement *)getStatement:(NSUInteger)index {
    if (index > [_statements count] - 1) {
        @throw [[DesignByContractException alloc] initWithReason:[NSString stringWithFormat:@"no conversation exists at index %ld", (long) index]];
    }

    return _statements[index];
}

- (void)addStatement:(NSString *)statement {
    [self addFoodUserStatement:statement semanticId:[NSString stringWithFormat:@"U:CuisinePreference=%@", statement]];

    RACSignal *bestRestaurant = [_restaurantSearch findBest];
    @weakify(self);
    [bestRestaurant subscribeError:^(NSError *error){
        @strongify(self);
        if (error.class == [LocationServiceAuthorizationStatusDeniedError class]) {
            NSString *text = @"Ooops... I can't find out my current location.\n\nI need to know where I am.\n\nPlease turn Location Services on at Settings > Privacy > Location Services.";
            [self addFoodHeroStatement:text semanticId:@"FH:BecauseUserDeniedAccessToLocationServices"];
        }
        else if (error.class == [LocationServiceAuthorizationStatusRestrictedError class]) {
            NSString *text = @"I’m terribly sorry but there is a problem. I can’t access Location Services. I need access to Location Services in order that I know where I am.";
            [self addFoodHeroStatement:text semanticId:@"FH:BecauseUserIsNotAllowedToUseLocationServices"];
        }
        else if (error.class == [NoRestaurantsFoundError class]){
            NSString *text = @"That’s weird. I can’t find any restaurants right now.";
            [self addFoodHeroStatement:text semanticId:@"FH:NoRestaurantsFound"];
        }
    }];
    [bestRestaurant subscribeNext:^(id next){
        @strongify(self);
        Restaurant *restaurant = next;
        NSString *nameAndPlace = [NSString stringWithFormat:@"%@, %@", restaurant.name, restaurant.vicinity];
        NSString *text = [[NSString alloc] initWithFormat:@"Maybe you like the '%@'?", nameAndPlace];

        [self addFoodHeroStatement:text semanticId:[NSString stringWithFormat:@"FH:Suggestion=%@", statement]];
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
