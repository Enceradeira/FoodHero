//
// Created by Jorg on 01/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ExpectedStatement : NSObject
@property(nonatomic, readonly) NSString *semanticId;
@property(nonatomic, readonly) NSString* state;

- (instancetype)initWithText:(NSString *)text inputAction:(NSString*)inputAction;
@end