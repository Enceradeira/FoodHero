//
// Created by Jorg on 24/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUAction.h"


@interface UAction : NSObject <IUAction>
- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToAction:(UAction *)action;

- (NSUInteger)hash;
@end