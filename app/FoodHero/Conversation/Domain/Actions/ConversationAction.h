//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Persona;


@interface ConversationAction : NSObject
@property(nonatomic, readonly) Persona *persona;

@property(nonatomic, readonly) NSString *text;

@property(nonatomic, readonly) NSString *responseId;

- (id)init:(Persona *)persona responseId:(NSString *)responseId text:(NSString *)text;

- (ConversationAction *)concat:(ConversationAction *)action;
@end