//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Persona.h"


@interface ConversationToken : NSObject

@property(nonatomic, readonly) NSString *semanticId;
@property(nonatomic, readonly) NSString *parameter;
@property(nonatomic, readonly) Persona *persona;

- (instancetype)initWithParameter:(NSString *)semanticId parameter:(NSString *)parameter;

- (ConversationToken *)concat:(ConversationToken *)token;

@end