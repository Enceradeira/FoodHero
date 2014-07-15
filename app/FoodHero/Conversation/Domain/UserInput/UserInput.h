//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserInput : NSObject

@property(nonatomic, readonly) NSString *semanticId;
@property(nonatomic, readonly) NSString *parameter;

- (id)init:(NSString *)semanticId parameter:(NSString *)parameter;
@end