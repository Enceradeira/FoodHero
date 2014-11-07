//
// Created by Jorg on 06/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@protocol IPhoto <NSObject>
- (RACSignal *)image;

- (BOOL)isEagerlyLoaded;
@end