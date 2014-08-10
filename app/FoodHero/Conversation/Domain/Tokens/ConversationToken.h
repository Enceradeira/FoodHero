//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Persona.h"


@interface ConversationToken : NSObject

@property(nonatomic, readonly) NSString *semanticId;
@property(nonatomic, readonly) NSString *text;
@property(nonatomic, readonly) Persona *persona;

- (instancetype)initWithSemanticId:(NSString *)semanticId text:(NSString *)text;

- (ConversationToken *)concat:(ConversationToken *)token;

@end