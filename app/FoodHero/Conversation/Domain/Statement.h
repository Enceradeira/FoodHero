//
//  Statement.h
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Persona.h"
#import "ConversationAction.h"
#import "IUAction.h"
#import "Restaurant.h"
#import "ConversationToken.h"


@interface Statement : NSObject

@property(nonatomic, readonly) ConversationToken * token;

- (NSString *)text;

- (NSString *)semanticId;

- (Persona *)persona;

- (id)initWithToken:(ConversationToken *)token inputAction:(id <IUAction>)inputAction;

+ (Statement *)create:(ConversationToken *)token inputAction:(id <IUAction>)inputAction;

- (id <IUAction>)inputAction;

- (Restaurant *)suggestedRestaurant;

@end
