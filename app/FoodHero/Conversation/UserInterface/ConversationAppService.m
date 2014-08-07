//
//  ConversationAppService.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "ConversationAppService.h"
#import "ConversationBubbleFoodHero.h"
#import "ConversationBubbleUser.h"
#import "Personas.h"
#import "Cuisine.h"

@implementation ConversationAppService {
    NSMutableDictionary *_bubbles;
    Conversation *_conversation;
    NSArray *_cuisines;
}

- (id)initWithDependencies:(ConversationRepository *)conversationRepository {
    self = [super init];
    if (self != nil) {
        _bubbles = [NSMutableDictionary new];
        _conversation = conversationRepository.get;
        _cuisines =
                [@[@"African", @"American", @"Asian", @"Bakery", @"Barbecue", @"British", @"Café", @"Cajun & Creole", @"Caribbean", @"Chinese", @"Continental", @"Delicatessen", @"Dessert", @"Eastern European", @"Fusion", @"European", @"French", @"German", @"Global/International", @"Greek", @"Indian", @"Irish", @"Italian", @"Japanese", @"Mediterranean", @"Mexican/Southwestern", @"Middle Eastern", @"Pizza", @"Pub", @"Seafood", @"Soups", @"South American", @"Spanish", @"Steakhouse", @"Sushi", @"Thai", @"Vegetarian", @"Vietnamese"]
                        linq_select:^(NSString *name) {
                            return [Cuisine create:name];
                        }];
    }
    return self;
}

- (void)addUserInput:(ConversationToken *)userInput {
    [_conversation addToken:userInput];
}

- (NSInteger)getStatementCount {
    return _conversation.getStatementCount;
}

- (ConversationBubble *)getStatement:(NSUInteger)index bubbleWidth:(CGFloat)bubbleWidth {

    NSString *key = [NSString stringWithFormat:@"%ld-%ld", (long) index, (long) bubbleWidth];
    ConversationBubble *bubble = _bubbles[key];
    if (bubble == nil) {
        Statement *statement = [_conversation getStatement:index];

        if (statement.persona == Personas.foodHero) {
            bubble = [[ConversationBubbleFoodHero alloc] initWithStatement:statement width:bubbleWidth index:index inputAction:statement.inputAction];
        }
        else {
            bubble = [[ConversationBubbleUser alloc] initWithStatement:statement width:bubbleWidth index:index];
        }

        _bubbles[key] = bubble;
    }
    return bubble;
}

- (RACSignal *)statementIndexes {
    return _conversation.statementIndexes;
}

- (NSInteger)getCuisineCount {
    return _cuisines.count;
}

- (Cuisine *)getCuisine:(NSUInteger)index {
    return _cuisines[index];
}

- (NSString *)getSelectedCuisineText {
    NSMutableString *text = [NSMutableString new];
    NSArray *cuisines = [[_cuisines
            linq_where:^(Cuisine *c) {
                return c.isSelected;
            }]
            linq_sort:^(Cuisine *c) {
                return c.isSelectedTimeStamp;
            }];

    for (NSInteger i = 0; i < cuisines.count; i++) {
        Cuisine *cuisine = cuisines[(NSUInteger) i];
        [text appendString:cuisine.name];
        if (i <= (NSInteger) cuisines.count - 3) {
            [text appendString:@", "];
        }
        else if (i <= (NSInteger) cuisines.count - 2) {
            [text appendString:@" or "];
        }
    }

    return text;
}
@end
