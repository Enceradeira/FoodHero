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
#import "UAction.h"

@interface Statement : NSObject

@property(nonatomic, readonly) NSString *text;
@property(nonatomic, readonly) NSString *semanticId;
@property(nonatomic, readonly) Persona *persona;

- (id <UAction>)inputAction;

- (id)initWithText:(NSString *)text semanticId:(NSString *)semanticId persona:(Persona *)persona inputAction:(id <UAction>)inputAction;
@end
