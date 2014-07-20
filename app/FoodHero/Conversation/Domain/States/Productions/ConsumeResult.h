//
// Created by Jorg on 20/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConsumeResult <NSObject>
- (BOOL)isStateFinished;

- (BOOL)isTokenConsumed;

- (BOOL)isTokenNotConsumed;
@end