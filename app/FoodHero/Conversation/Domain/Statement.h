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
#import "ConversationToken.h"


@interface Statement : NSObject

@property(nonatomic, readonly) ConversationToken * token;

- (NSString *)text;

- (NSString *)semanticId;

- (Persona *)persona;

+ (instancetype)createWithSemanticId:(NSString *)semanticId text:(NSString *)text state:(NSString *)state suggestedRestaurant:(Restaurant *)restaurant;

- (NSString*)state;

- (Restaurant *)suggestedRestaurant;

@end
