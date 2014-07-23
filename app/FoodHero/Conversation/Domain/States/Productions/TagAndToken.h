//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#include "RepeatSymbol.h"

@interface TagAndToken : NSObject
@property(nonatomic, readonly) NSString *tag;
@property(nonatomic, readonly) ConversationToken * token;

- (instancetype)initWithTag:(NSString *)tag token:(ConversationToken *)token;

+ (instancetype)create:(NSString *)tag token:(ConversationToken *)token;
@end

