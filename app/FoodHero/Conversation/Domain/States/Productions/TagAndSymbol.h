//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#include "RepeatSymbol.h"

@interface TagAndSymbol : NSObject
@property(nonatomic, readonly) NSString *tag;
@property(nonatomic, readonly) id <RepeatSymbol> symbol;

- (instancetype)initWithTag:(NSString *)tag symbol:(id <RepeatSymbol>)symbol;
@end

