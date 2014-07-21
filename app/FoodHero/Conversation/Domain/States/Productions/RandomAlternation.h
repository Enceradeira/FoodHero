//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alternation.h"


@interface RandomAlternation : AlternationBase
+ (instancetype)create:(NSString *)tag1, ...;

- (id)initWithTags:(NSArray *)tagAndSymbols;
@end