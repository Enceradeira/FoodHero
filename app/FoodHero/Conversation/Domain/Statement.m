//
//  Statement.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Conversation.h"
#import "Personas.h"
#import "FoodHero-Swift.h"

@implementation Statement {
    NSString *_state;
    NSString *_text;
    NSString *_semanticId;
    Restaurant *_suggestedRestaurant;
    ExpectedUserUtterances *_expectedUserUtterances;
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

- (instancetype)initWithSemanticId:(NSString *)semanticId
                              text:(NSString *)text
                             state:(NSString *)state
               suggestedRestaurant:(Restaurant *)restaurant
            expectedUserUtterances:(ExpectedUserUtterances *)expectedUserUtterances {
    self = [super init];
    if (self != nil) {
        _state = state;
        _text = text;
        _semanticId = semanticId;
        _suggestedRestaurant = restaurant;
        _expectedUserUtterances = expectedUserUtterances;
    }
    return self;
}

+ (instancetype)createWithSemanticId:(NSString *)semanticId
                                text:(NSString *)text
                               state:(NSString *)state
                 suggestedRestaurant:(Restaurant *)restaurant
              expectedUserUtterances:(ExpectedUserUtterances *)expectedUserUtterances {
    return [[Statement alloc] initWithSemanticId:semanticId
                                            text:text state:state
                             suggestedRestaurant:restaurant
                          expectedUserUtterances:expectedUserUtterances];
}

- (NSString *)state {
    return _state;
}

- (Restaurant *)suggestedRestaurant {
    return _suggestedRestaurant;
}

- (ExpectedUserUtterances *)expectedUserUtterances{
    return _expectedUserUtterances;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_state forKey:@"_state"];
    [coder encodeObject:_text forKey:@"_text"];
    [coder encodeObject:_semanticId forKey:@"_semanticId"];
    [coder encodeObject:_suggestedRestaurant forKey:@"_suggestedRestaurant"];
    [coder encodeObject:_expectedUserUtterances forKey:@"_expectedUserUtterances"];
}

- (id)initWithCoder:(NSCoder *)coder {
    return [self initWithSemanticId:[coder decodeObjectForKey:@"_semanticId"]
                               text:[coder decodeObjectForKey:@"_text"]
                              state:[coder decodeObjectForKey:@"_state"]
                suggestedRestaurant:[coder decodeObjectForKey:@"_suggestedRestaurant"]
             expectedUserUtterances:[coder decodeObjectForKey:@"_expectedUserUtterances"]]  ;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToStatement:other];
}

- (BOOL)isEqualToStatement:(Statement *)statement {
    if (self == statement)
        return YES;
    if (statement == nil)
        return NO;
    if (_state != statement->_state && ![_state isEqualToString:statement->_state])
        return NO;
    if (_text != statement->_text && ![_text isEqualToString:statement->_text])
        return NO;
    if (_semanticId != statement->_semanticId && ![_semanticId isEqualToString:statement->_semanticId])
        return NO;
    if (_suggestedRestaurant != statement->_suggestedRestaurant && ![_suggestedRestaurant isEqualToRestaurant:statement->_suggestedRestaurant])
        return NO;
    if (_expectedUserUtterances != statement->_expectedUserUtterances && ![_expectedUserUtterances isEqual:statement->_expectedUserUtterances])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [_state hash];
    hash = hash * 31u + [_text hash];
    hash = hash * 31u + [_semanticId hash];
    hash = hash * 31u + [_suggestedRestaurant hash];
    hash = hash * 31u + [_expectedUserUtterances hash];
    return hash;
}


@end
