//
//  Statement.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Conversation.h"
#import "Personas.h"

@implementation Statement {
    NSString *_state;
    NSString *_text;
    NSString *_semanticId;
    Restaurant *_suggestedRestaurant;
}
- (NSString *)text {
    return _text;
}

- (NSString *)semanticId {
    return _semanticId;
}

- (Persona *)persona {
    if ([_semanticId rangeOfString:@"FH:"].location == NSNotFound) {
        return [Personas user];
    }
    return [Personas foodHero];
}

- (instancetype)initWithSemanticId:(NSString *)semanticId text:(NSString *)text state:(NSString *)state suggestedRestaurant:(Restaurant *)restaurant {
    self = [super init];
    if (self != nil) {
        _state = state;
        _text = text;
        _semanticId = semanticId;
        _suggestedRestaurant = restaurant;
    }
    return self;
}

+ (instancetype)createWithSemanticId:(NSString *)semanticId text:(NSString *)text state:(NSString *)state suggestedRestaurant:(Restaurant *)restaurant {
    return [[Statement alloc] initWithSemanticId:semanticId text:text state:state suggestedRestaurant:restaurant];
}

- (NSString *)state {
    return _state;
}

- (Restaurant *)suggestedRestaurant {
    return _suggestedRestaurant;
}

@end
