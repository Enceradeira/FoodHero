//
//  Statement.h
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Persona.h"
#import "Restaurant.h"

@class ExpectedUserUtterances;

@interface Statement : NSObject<NSCoding>

- (instancetype)initWithSemanticId:(NSString *)semanticId text:(NSString *)text state:(NSString *)state suggestedRestaurant:(Restaurant *)restaurant expectedUserUtterances:(ExpectedUserUtterances *)expectedUserUtterances;

- (NSString *)text;

- (NSString *)semanticId;

- (Persona *)persona;

+ (instancetype)createWithSemanticId:(NSString *)semanticId
                                text:(NSString *)text
                               state:(NSString *)state
                 suggestedRestaurant:(Restaurant *)restaurant
              expectedUserUtterances:(ExpectedUserUtterances*)expectedUserUtterances;

- (NSString *)state;

- (Restaurant *)suggestedRestaurant;

- (ExpectedUserUtterances *)expectedUserUtterances;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToStatement:(Statement *)statement;

- (NSUInteger)hash;

@end
